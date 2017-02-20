class UsersController < ApplicationController
before_action :current_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @distances  = @user.distances

    @test16 = Distance.where(verkehrsmittel: "DRIVING", user_id: current_user).sum(:gmaprange)



    @chart1 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Zurückgelegte Kilometer nach Verkehrsmittel")
      f.xAxis(categories:  ["Auto", "öffentlicher Verkehr", "Fahrrad", "Zu Fuss"])
      f.series(name: "Kilomenter", yAxis: 0, data: [
          Distance.where(verkehrsmittel: "DRIVING", user_id: current_user).sum(:gmaprange),
          Distance.where(verkehrsmittel: "TRANSIT", user_id: current_user).sum(:gmaprange),
          Distance.where(verkehrsmittel: "BICYCLING", user_id: current_user).sum(:gmaprange),
          Distance.where(verkehrsmittel: "WALKING", user_id: current_user).sum(:gmaprange)
        ]
       )

      f.yAxis [
        {title: {text: "Kilomenter", margin: 10} },
      ]
      f.chart({defaultSeriesType: "column"})
    end

    @chart4 = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 50, 60, 50]} )
      series = {
        :type=> 'pie',
        :name=> 'Verkehrsmittel Verteilung',
        :data=> [
          ['Auto', Distance.where(verkehrsmittel: "DRIVING", user_id: current_user).sum(:gmaprange)],
          ['öffentliche Verkehrsmittel', Distance.where(verkehrsmittel: "TRANSIT", user_id: current_user).sum(:gmaprange)],
          ['Fahrrad', Distance.where(verkehrsmittel: "BICYCLING", user_id: current_user).sum(:gmaprange)],
          ['Zu fuss', Distance.where(verkehrsmittel: "WALKING", user_id: current_user).sum(:gmaprange)]
        ]
      }
      f.series(series)
      f.options[:title][:text] = "Prozentuelle Verteilung"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
      f.plot_options(:pie=>{
        :allowPointSelect=>true,
        :cursor=>"pointer" ,
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end

    @chart5 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Fahrten im Zeitverlauf")
      f.xAxis(
        type: 'datetime',
        categories: giv_me_date
       )

      f.series(:name => "Kilometer",
              :data => @distances.map{ |f| [f.created_at.utc.strftime("%F %X"+" UTC"), f.gmaprange.to_f]}
      )

      f.yAxis [
        {:title => {:text => "Kilometer", :margin => 10} }
      ]

      f.chart({:defaultSeriesType=>"line"})
    end

    @chart6 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Zurückgelegte Kilometer nach Verkehrsmittel I")
      f.xAxis(
        type: 'linear',
        categories: ["Auto", "öffentlicher Verkehr", "Fahrrad", "Zu Fuss"]
       )

      f.series(:name => ["Auto", "öffentlicher Verkehr", "Fahrrad", "Zu Fuss"],
              :data => [
                ['Auto', @test16],
                ['öffentliche Verkehrsmittel', @test16],
                ['Fahrrad', @test16],
                ['Zu fuss', @test16]
              ]
      )

      f.yAxis [
        {:title => {:text => "Kilometer", :margin => 10} }
      ]

      f.chart({:defaultSeriesType=>"line"})
    end

    @chart7 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Zurückgelegte Kilometer nach Verkehrsmittel II")
      f.xAxis(
        categories: ["Auto", "öffentlicher Verkehr", "Fahrrad", "Zu Fuss"]
       )

      f.series(:name => ["Auto", "öffentlicher Verkehr", "Fahrrad", "Zu Fuss"],
              :data => [
                ['Auto', Distance.where(verkehrsmittel: "DRIVING", user_id: current_user).sum(:gmaprange)],
                ['öffentliche Verkehrsmittel', Distance.where(verkehrsmittel: "TRANSIT", user_id: current_user).sum(:gmaprange)],
                ['Fahrrad', Distance.where(verkehrsmittel: "BICYCLING", user_id: current_user).sum(:gmaprange)],
                ['Zu fuss', Distance.where(verkehrsmittel: "WALKING", user_id: current_user).sum(:gmaprange)]
              ]
      )

      f.yAxis [
        {:title => {:text => "Kilometer", :margin => 10} }
      ]

      f.chart({:defaultSeriesType=>"line"})
    end
  end

  def create
      @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:success] = "Sie haben sich erfolgreich registriert!"
        redirect_to @user # Handle a successful save.
      else
        render 'new'
      end
  end


  def data_new
    @distances.map{ |f| [f.created_at.utc.strftime("%F %X"+" UTC"), f.gmaprange.to_f]}.inspect
  end

  def data_helper
    @test16 = Distance.where(verkehrsmittel: "DRIVING", user_id: current_user).sum(:gmaprange)
  end


   def init()
   mess = []
   # -- save me the SUM() of Messages for every day in the last week
   (0..6).each do  |i|
     mess[i] = Distance.count
   end
 end

  private

  def user_params
    params.require(:user).permit(:first_name, :name, :email, :password,
                                 :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def giv_me_date
    date = []
    (1..7).each do  |i|
      date[i] = Time.now - (60 * 60 * 24)*(i-1)
      date[i] = date[i].strftime("%d/%m")
    end
   return date.reverse
 end

end
