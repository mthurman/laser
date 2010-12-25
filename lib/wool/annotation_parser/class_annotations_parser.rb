# Autogenerated from a Treetop grammar. Edits may be lost.


module Wool
  module Parsers
    module Class
      include Treetop::Runtime

      def root
        @root ||= :variance_constraint
      end

      module VarianceConstraint0
        def constant
          elements[0]
        end

      end

      module VarianceConstraint1
        def constraints
          constant.constraints.map {|x| x.variance = :invariant; x }
        end
      end

      module VarianceConstraint2
        def constant
          elements[0]
        end

      end

      module VarianceConstraint3
        def constraints
          constant.constraints.map {|x| x.variance = :contravariant; x }
        end
      end

      module VarianceConstraint4

        def constraints
          constant.constraints
        end
      end

      def _nt_variance_constraint
        start_index = index
        if node_cache[:variance_constraint].has_key?(index)
          cached = node_cache[:variance_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_constant
        s1 << r2
        if r2
          if has_terminal?("=", false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("=")
            r3 = nil
          end
          s1 << r3
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(VarianceConstraint0)
          r1.extend(VarianceConstraint1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          i4, s4 = index, []
          r5 = _nt_constant
          s4 << r5
          if r5
            if has_terminal?("-", false, index)
              r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("-")
              r6 = nil
            end
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(VarianceConstraint2)
            r4.extend(VarianceConstraint3)
          else
            @index = i4
            r4 = nil
          end
          if r4
            r0 = r4
          else
            r7 = _nt_constant
            if r7
              r0 = r7
            else
              @index = i0
              r0 = nil
            end
          end
        end

        node_cache[:variance_constraint][start_index] = r0

        r0
      end

      module HashConstraint0
        def variance_constraint1
          elements[0]
        end

        def variance_constraint2
          elements[2]
        end
      end

      module HashConstraint1
        def constraints
          [Constraints::GenericClassConstraint.new('Hash', elements.first.class_name, elements[2].class_name)]
        end
      end

      def _nt_hash_constraint
        start_index = index
        if node_cache[:hash_constraint].has_key?(index)
          cached = node_cache[:hash_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_variance_constraint
        s1 << r2
        if r2
          if has_terminal?('=>', false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('=>')
            r3 = nil
          end
          s1 << r3
          if r3
            r4 = _nt_variance_constraint
            s1 << r4
          end
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(HashConstraint0)
          r1.extend(HashConstraint1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          r5 = _nt_variance_constraint
          if r5
            r0 = r5
          else
            @index = i0
            r0 = nil
          end
        end

        node_cache[:hash_constraint][start_index] = r0

        r0
      end

      module Constant0
      end

      module Constant1
        def constraints
          [Constraints::ClassConstraint.new(text_value, :covariant)]
        end
      end

      def _nt_constant
        start_index = index
        if node_cache[:constant].has_key?(index)
          cached = node_cache[:constant][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        s0, i0 = [], index
        loop do
          i1, s1 = index, []
          if has_terminal?('::', false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('::')
            r3 = nil
          end
          if r3
            r2 = r3
          else
            r2 = instantiate_node(SyntaxNode,input, index...index)
          end
          s1 << r2
          if r2
            if has_terminal?('\G[A-Z]', true, index)
              r4 = true
              @index += 1
            else
              r4 = nil
            end
            s1 << r4
            if r4
              s5, i5 = [], index
              loop do
                if has_terminal?('\G[A-Za-z_]', true, index)
                  r6 = true
                  @index += 1
                else
                  r6 = nil
                end
                if r6
                  s5 << r6
                else
                  break
                end
              end
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              s1 << r5
            end
          end
          if s1.last
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
            r1.extend(Constant0)
          else
            @index = i1
            r1 = nil
          end
          if r1
            s0 << r1
          else
            break
          end
        end
        if s0.empty?
          @index = i0
          r0 = nil
        else
          r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
          r0.extend(Constant1)
        end

        node_cache[:constant][start_index] = r0

        r0
      end

    end

    class ClassParser < Treetop::Runtime::CompiledParser
      include Class
    end

  end
end