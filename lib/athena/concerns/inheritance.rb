# frozen_string_literal: true

module Athena
  module Concerns
    module Inheritance
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def abstract_class=(value)
          @abstract_class = value
          # Unregister from parent's subcommands when marked abstract
          if value && respond_to?(:command_name) && self < Athena::Command
            parent = superclass
            parent.subcommands.delete(command_name) if parent.respond_to?(:subcommands)
          end
        end

        def abstract_class?
          @abstract_class == true
        end

        # Returns the class descending directly from Athena::Command, or
        # an abstract class, if any, in the inheritance hierarchy.
        #
        # If A extends Command, A.base_class returns A.
        # If B < A through some hierarchy, B.base_class returns A.
        # If A is abstract, both B.base_class and C.base_class return B.
        def base_class
          unless self < Athena::Command
            raise Athena::Error, "#{name} doesn't belong in a hierarchy descending from Athena::Command"
          end

          if superclass == Athena::Command || superclass.abstract_class?
            self
          else
            superclass.base_class
          end
        end
      end
    end
  end
end
