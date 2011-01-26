module Laser
  module SexpAnalysis
    # Visitor: a set of methods for visiting an AST. The
    # default implementations visit each child and do no
    # other processing. By including this module, and
    # implementing certain methods, you can do your own
    # processing on, say, every instance of a :rescue AST node.
    # The default implementation will go arbitrarily deep in the AST
    # tree until it hits a method you define.
    module Visitor
      extend ModuleExtensions
      def self.included(klass)
        klass.__send__(:extend, ClassMethods)
        klass.__send__(:extend, ModuleExtensions)
        klass.cattr_accessor_with_default :filters, []
      end
      module ClassMethods
        extend ModuleExtensions
        class Filter < Struct.new(:args, :blk)
          def matches?(node)
            args.any? do |filter|
              case filter
              when ::Symbol then node.type == filter
              when Proc then filter.call(node, *node.children)
              end
            end
          end
          def run(node, visitor)
            visitor.instance_exec(node, *node.children, &blk)
          end
        end
        def add(*args, &blk)
          (self.filters ||= []) << Filter.new(args, blk)
        end
      end
      
      attr_reader :text
      # Annotates the given node +root+, assuming the tree represents the source contained in
      # +text+. This is useful for text-based discovery that has to happen, often to capture
      # lexing information lost by the Ripper parser.
      #
      # root: Sexp
      # text: String
      def annotate_with_text(root, text)
        @text = text
        annotate! root
      end
      
      # Entry point for annotation. Should be called on the root of the tree we
      # are interested in annotating.
      #
      # root: Sexp
      def annotate!(root)
        visit root
      end

      # Visits a given node. Will be automatically called by the visitor and can (and often
      # should) be called manually.
      #
      # node: Sexp
      def visit(node)
        case node
        when Sexp
          case node[0]
          when ::Symbol
            send("visit_#{node[0]}", node)
          when Array
            default_visit(node)
          end
        end
      end
      
      # Visits the children of the node, by calling #visit on every child of
      # node that is a Sexp.
      #
      # node: Sexp
      def visit_children(node)
        node.children.select {|x| Sexp === x}.each {|x| visit(x) }
      end
      # By default, we should visit every child, trying to find something the visitor
      # subclass has overridden.
      alias_method :default_visit, :visit_children
      
      # Tries all known filters on the given node, and if the filter matches, then
      # the filter is run on the node. Returns whether or not any filters matched.
      #
      # node: Sexp
      # return: Boolean
      def try_filters(node)
        filters = self.class.filters.select { |filter| filter.matches?(node) }
        if filters.any?
          filters.each { |filter| filter.run(node, self) }
          true
        end
      end
      
      # The visitor handles dispatch on a node of type :type by calling visit_type.
      #
      # generates: /visit_([a-z]+)/
      def method_missing(meth, *args, &blk)
        if meth.to_s[0,6] == 'visit_' && meth.to_s.size > 6
          try_filters args.first or default_visit args.first
        else
          super
        end
      end
      
      ################## Source text manipulation methods ###############
      
      def lines
        @lines ||= text.lines.to_a
      end
      
      ################## Scope management methods #######################
      
      attr_accessor_with_default :scope_stack, [Scope::GlobalScope]
      def enter_scope(scope)
        @current_scope = scope
        scope_stack.push scope
      end

      def exit_scope
        scope_stack.pop
        @current_scope = scope_stack.last
      end

      # Yields with the current scope preserved.
      def with_scope(scope)
        enter_scope scope
        yield
      ensure
        exit_scope
      end
      
      def visit_with_scope(node, scope)
        with_scope(scope) { visit(node) }
      end
    end
  end
end