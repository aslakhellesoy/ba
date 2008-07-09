module BaPageExt
  def self.included(base)
    base.class_eval do 
      belongs_to :price
      has_many :attendances

      def new_attendance(attrs)
        attendances.build(attrs)
      end
    end
  end
end
