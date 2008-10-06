class AddAttendanceTicketCode < ActiveRecord::Migration
  def self.up
    add_column :attendances, :ticket_code, :string
    attendances = Attendance.find(:all)
    Attendance.transaction do
      attendances.each do |attendance|
        attendance.create_ticket_code
      end
    end
  end
  
  def self.down
    remove_column :attendances, :ticket_code
  end
end
