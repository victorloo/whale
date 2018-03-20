
namespace :dev do
  
  def rand_in_range(from, to)
    rand * (to - from) + from
  end
  
  def rand_time(from, to=Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
  end
  
  task fake_members: :environment do
    Member.destroy_all
    
    50.times do |i|
      phone_number = 10000000 + rand(80000000)
      phone_string = '09' + phone_number.to_s
      member = Member.new(
        name: FFaker::Name::first_name,
        gender: FFaker::GenderCN.random,
        phone: phone_string,
        birthday: FFaker::IdentificationESCO::expedition_date,
        email: FFaker::Internet::email,
        skin_type: SkinType.all.sample,
        hair_code: HairType.all.sample.code,
        member_code: MemberType.all.sample.code
        )
      member.save!
    end
    puts "create fake members, have #{Member.count} guests data"
  end
  
  task fake_guests: :environment do
    Guest.destroy_all
    
    90.times do |i|
      Guest.create!(
        payment: 100+rand(50000),
        gender: FFaker::GenderCN.random,
        guest_type: GuestType.all.sample,
        country: Country.all.sample,
        age: Age.all.sample,
        info_way: InfoWay.all.sample,
        user: User.all.sample
      )
    end
    
    guests = Guest.all
    
    guests.each do |g|
      dat = rand_time(7.days.ago).to_s
      first = dat[0..10]
      middle = 10 + rand(11)
      last = dat[13..-1]
      rand_date = first + middle.to_s + last
      
      g.created_at = rand_date
      g.save
    end
    
    puts "create fake guests, have #{Guest.count} guests data"
  end

  task fake_bulletins: :environment do
    Bulletin.destroy_all
    
    3.times do |i|
      Bulletin.create!(
        start_date: rand_time(7.days.ago).to_s,
        end_date: Date.today,
        title: "洗手露半價活動",
        content: "髮身系列任兩件，享洗手露(330mL)半價優惠",
        user: User.all.sample
      )
    end
    
    3.times do |i|
      Bulletin.create!(
        start_date: FFaker::Time.date,
        end_date: Date.today,
        title: "青蜜乳液活動",
        content: "330mL青蜜滋養乳液＋髮或身系列330mL任選，贈50mL荷葉沐浴露（價值130元）",
        user: User.all.sample
      )
    end
    
    Bulletin.create!(
      start_date: FFaker::Time.date,
      end_date: Date.today,
      title: "隨單贈",
      content: "贈品牌季刊乙本",
      user: User.all.sample
    )
    
    Bulletin.create!(
      start_date: FFaker::Time.date,
      end_date: Date.today,
      title: "滿額禮",
      content: "滿2500, 贈小鹿版畫禮盒",
      user: User.all.sample
    )
    
    puts "create fake bulletins, have #{Bulletin.count} bulletins data"
  end  
  
  task fake_all: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_members'].execute
    Rake::Task['dev:fake_guests'].execute
    Rake::Task['dev:fake_bulletins'].execute
    # Rake::Task['dev:fake_products'].execute
  end
  
  task fake_all_2: :environment do
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_members'].execute
    Rake::Task['dev:fake_guests'].execute
    Rake::Task['dev:fake_bulletins'].execute
  end
  
end
