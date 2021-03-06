# Autogenerated from a Treetop grammar. Edits may be lost.


require 'laser/annotation_parser/useful_parsers_parser'
module Laser
  module Parsers
    module Overload
      include Treetop::Runtime

      def root
        @root ||= :function_type
      end

      include GeneralPurpose

      module FunctionType0
        def parenthesized_type_list
          elements[0]
        end

        def return_type
          elements[4]
        end
      end

      module FunctionType1
        def type
          result = Types::GenericType.new(
              Types::PROC,
              [Types::TupleType.new(parenthesized_type_list.all_types), return_type.type])
        end
      end

      module FunctionType2
        def parenthesized_type_list
          elements[0]
        end

        def return_type
          elements[2]
        end
      end

      module FunctionType3
        def type
          result = Types::GenericType.new(
              Types::PROC,
              [Types::TupleType.new(parenthesized_type_list.all_types), return_type.type])
        end
      end

      def _nt_function_type
        start_index = index
        if node_cache[:function_type].has_key?(index)
          cached = node_cache[:function_type][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_parenthesized_type_list
        s1 << r2
        if r2
          s3, i3 = [], index
          loop do
            r4 = _nt_space
            if r4
              s3 << r4
            else
              break
            end
          end
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          s1 << r3
          if r3
            if has_terminal?('->', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('->')
              r5 = nil
            end
            s1 << r5
            if r5
              s6, i6 = [], index
              loop do
                r7 = _nt_space
                if r7
                  s6 << r7
                else
                  break
                end
              end
              r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
              s1 << r6
              if r6
                r8 = _nt_type
                s1 << r8
              end
            end
          end
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(FunctionType0)
          r1.extend(FunctionType1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          i9, s9 = index, []
          r10 = _nt_parenthesized_type_list
          s9 << r10
          if r10
            s11, i11 = [], index
            loop do
              r12 = _nt_space
              if r12
                s11 << r12
              else
                break
              end
            end
            r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
            s9 << r11
            if r11
              r13 = _nt_type
              s9 << r13
            end
          end
          if s9.last
            r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
            r9.extend(FunctionType2)
            r9.extend(FunctionType3)
          else
            @index = i9
            r9 = nil
          end
          if r9
            r0 = r9
          else
            @index = i0
            r0 = nil
          end
        end

        node_cache[:function_type][start_index] = r0

        r0
      end

    end

    class OverloadParser < Treetop::Runtime::CompiledParser
      include Overload
    end

  end
end
