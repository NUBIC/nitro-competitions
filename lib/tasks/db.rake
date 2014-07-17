namespace :db do

  task :admin_maintenance => :environment do
    cfar_admins = [
      %w(rtd723 Rich D'Aquila RICHARD.DAQUILA@northwestern.edu),
      %w(bsm292 Brian Mustanski brian@northwestern.edu),
      %w(rlm065 Rob Murphy r-murphy@northwestern.edu),
      %w(tba936 Babefemi Taiwo b-taiwo@northwestern.edu),
      %w(tjh769 Tom Hope thope@northwestern.edu),
      %w(rlong Rich Longnecker r-longnecker@northwestern.edu),
      %w(aga261 Anabel Mendez anabel.mendez@northwestern.edu),
      %w(agd118 Ahmane Glover ahmane.glover@northwestern.edu),
      %w(pfr957 Paul Friedman p-friedman@northwestern.edu),
      %w(myu793 Mara Yurasek m-yurasek@northwestern.edu),
    ]
    cfar = Program.find_by_program_name("CFAR")
    create_admins_for_program(cfar_admins, cfar)

    mss_admins = [
      %w(hol855 Jane Holl j-holl@northwestern.edu),
      %w(fps166 Frank Penedo fpenedo@northwestern.edu),
      %w(rwchang Rowland Chang rwchang@northwestern.edu),
      %w(lsw201 Lauren Wakschlag lauriew@northwestern.edu),
      %w(dwb962 David Baker dwbaker@northwestern.edu),
      %w(dce946 David Cella d-cella@northwestern.edu),
      %w(cwy381 Clyde Yancy c-yancy@northwestern.edu),
      %w(mehrotra Sanjay Mehrotra mehrotra@northwestern.edu),
      %w(rta936 Ron Ackerman r.ackermann@northwestern.edu),
    ]
    mss = Program.find_by_program_name("MSS")
    create_mss_admins_for_program(mss_admins, mss)
  end

  def create_admins_for_program(users, program)
    users.each do |arr|
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
