# encoding: UTF-8
require 'set'
module Laser
  module SexpAnalysis
    # This module contains a class hierarchy that represents the type
    # hierarchy in the analyzed Ruby code. This is where method responsiveness
    # can be checked. Some protocols are simple, such as a InstanceProtocol,
    # which responds to all the methods that the corresponding Class does.
    # Some might be structural or dependent or generic! The key part is that
    # method signatures can be listed and queried.
    module Protocols
      # The base class for all protocols.
      class Base
        include Comparable

        # Provide a good generic inspect method: show the class name, and the
        # to_s form of the protocol. to_s should provide the form of the protocol
        # in annotation form, if possible, or otherwise be a concise explanation of
        # what the protocol represents.
        def inspect
          "#<#{self.class.name.split('::').last}: #{to_s}>"
        end

        # Returns the list of all known signatures that this protocol responds
        # to.
        #
        # @return [Array<Signature>] the supported signatures for this protocol.
        def signatures
          raise NotImplementedError.new('You must implement #signatures yourself.')
        end
        
        # Compares the protocol to another protocol by comparing their signatures
        # list (sorted).
        def <=>(other)
          Set.new(self.signatures) <=> Set.new(other.signatures)
        end
        
        # Unions the protocol with another.
        # @return [UnionProtocol]
        def |(other)
          UnionProtocol.new([self, other])
        end
      end
      
      # This protocol has literally no information known about it. :-(
      class UnknownProtocol < Base
        def to_s
          'Top'
        end

        def signatures
          []
        end
      end
      
      # This protocol consists of a predefined set of signatures. This is the
      # "duck type" of duck typing: the signatures are the quacking. A common
      # structural type is #read, which would be:
      #    StructuralProtocol.new
      class StructuralProtocol < Base
        extend ModuleExtensions
        attr_accessor_with_default :signatures, []
        def initialize(sigs)
          @signatures = sigs
        end
      end
      
      # This is a simple protocol whose signature set is just the union of the
      # signature sets of its constituent protocols.
      class UnionProtocol < Base
        # Initializes the Union protocol to a set of constituent protocols.
        #
        # @param [Array<Base>] constituents the set of constituent protocols that
        #    this protocol is a union of.
        def initialize(constituents)
          @protocols = constituents
        end
        
        def to_s
          @protocols.inject {|a, b| "#{a.to_s} | #{b.to_s}"}
        end
        
        # Returns the list of all known signatures that this protocol responds
        # to, which is the union of all the constituent protocols.
        #
        # @return [Array<Signature>] the supported signatures for this protocol.
        def signatures
          @protocols.map(&:signatures).inject(:|)
        end
      end

      # This is a simple protocol whose signature set is just the intersection of the
      # signature sets of its constituent protocols.
      class IntersectionProtocol < Base
        # Initializes the Intersection protocol to a set of constituent protocols.
        #
        # @param [Array<Base>] constituents the set of constituent protocols that
        #    this protocol is a union of.
        def initialize(constituents)
          @protocols = constituents
        end
        
        def to_s
          @protocols.inject {|a, b| "#{a.to_s} ∩ #{b.to_s}"}
        end
        
        # Returns the list of all known signatures that this protocol responds
        # to, which is the union of all the constituent protocols.
        #
        # @return [Array<Signature>] the supported signatures for this protocol.
        def signatures
          @protocols.map(&:signatures).inject(:&)
        end
      end
      
      # A protocol that has the same signatures as a given class.
      class InstanceProtocol < Base
        attr_reader :value

        # Initializes the class protocol with the given class.
        #
        # @param [LaserClass] klass the laser class whose protocol we are representing
        def initialize(instance)
          @value = instance
        end
        
        def to_s
          value.path
        end
        
        # Returns all the signatures that the class responds to, since this protocol
        # has the same signatures.
        #
        # @return [Array<Signature>] the supported signatures for this protocol.
        def signatures
          @value.instance_signatures
        end
      end
    end
  end
end