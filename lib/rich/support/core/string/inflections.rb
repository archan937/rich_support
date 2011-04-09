module Rich
  module Support
    module Core
      module String
        module Inflections

          def upcase_first
            empty? ?
              self :
              self[0].chr.capitalize + self[1, size]
          end

          def copy_case(s)
            send((:downcase unless s.dup.downcase!) || (:upcase unless s.dup.upcase!) || (:upcase_first unless s.dup.upcase_first!) || :to_s)
          end
          alias_method :cp_case, :copy_case

          def upcase_first!
            self == (result = upcase_first) ? nil : replace(result)
          end

          def copy_case!(s)
            self == (result = cp_case(s))   ? nil : replace(result)
          end
          alias_method :cp_case!, :copy_case!

          def singularize!
            downcase == (result = singularize).downcase ? nil : replace(result)
          end

          def pluralize!
            downcase == (result = pluralize).downcase   ? nil : replace(result)
          end

        end
      end
    end
  end
end