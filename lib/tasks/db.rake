namespace :db do

  task :admin_maintenance => :environment do
    create_admins_for_program(Program.find_by_program_name("CFAR"))
  end

  def create_admins_for_program(program)
    [
      %w(rtd723 Rich D'Aquila RICHARD.DAQUILA@northwestern.edu),
      %w(bsm292 Brian Mustanski brian@northwestern.edu),
      %w(rlm065 Rob Murphy r-murphy@northwestern.edu),
      %w(tba936 Babefemi Taiwo b-taiwo@northwestern.edu),
      %w(tjh769 Tom Hope thope@northwestern.edu),
      %w(rlong Rich Longnecker r-longnecker@northwestern.edu),
      %w(aga261 Anabel Mendez anabel.mendez@northwestern.edu),
      %w(agd118 Ahmane Glover ahmane.glover@northwestern.edu),
      %w(pfr957 Paul Friedman p-friedman@northwestern.edu),
    ].each do |arr|
      user = find_or_create_user(arr)
      create_admin_role(user, program) if user && program
    end
  end

  def create_admin_role(user, program)
    if user.roles_users.for_program(program.id).blank?
      ru = RolesUser.new
      ru.user = user
      ru.role = admin
      ru.program = program
      ru.save!
    end
  end

  def admin
    @admin ||= Role.where(name: 'Admin').first
  end

  def find_or_create_user(arr)
    user = User.where(username: arr[0]).first
    if user.blank?
      user = User.create username: arr[0],
                         first_name: arr[1],
                         last_name: arr[2],
                         email: arr[3]
    end
    user
  end

end
