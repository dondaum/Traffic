class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @distances  = @user.distances

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Zurückgelegte Kilometer nach Verkehrsmittel")
      f.xAxis(categories:  Distance.select(:verkehrsmittel).map(&:verkehrsmittel).uniq )
      f.series(name: "Kilomenter", yAxis: 0, data: [
          Distance.where(verkehrsmittel: "Bus", user_id: current_user).sum(:range),
          Distance.where(verkehrsmittel: "Flugzeug", user_id: current_user).sum(:range),
          Distance.where(verkehrsmittel: "Zug", user_id: current_user).sum(:range),
          Distance.where(verkehrsmittel: "Auto", user_id: current_user).sum(:range)
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
          ['Bus', Distance.where(verkehrsmittel: "Bus", user_id: current_user).sum(:range)],
          ['Flugzeug', Distance.where(verkehrsmittel: "Flugzeug", user_id: current_user).sum(:range)],
          ['Zug', Distance.where(verkehrsmittel: "Zug", user_id: current_user).sum(:range)],
          ['Auto', Distance.where(verkehrsmittel: "Auto", user_id: current_user).sum(:range)]
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
        type: 'datetime'
       )

      f.series(:name => "Kilomenter", :yAxis => 0, :data => [
        ["2017-01-15 11:01:16 UTC", 222], ["2017-01-20 11:01:16 UTC", 100], ["2017-01-30 11:01:16 UTC", 500]
        ])

      f.yAxis [
        {:title => {:text => "Kilometer", :margin => 70} },
        {:title => {:text => "Kilometer"}, :opposite => true},
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"line"})
    end

    @chart6 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Fahrten im Zeitverlauf")
      f.xAxis(
        type: 'datetime',
        dateTimeLabelFormats: {second: '%l:%M:%S %p',
                           minute: '%l:%M %p',
                           hour: '%l:%M %p',
                           day: '%e. %b', week: '%e. %b',
                           month: '%b \'%y', year: '%Y'}
       )

      f.series(:name => "Kilomenter", :yAxis => 0, :data => [
        ["2017-01-15 11:01:16 UTC", 222], ["2017-01-20 11:01:16 UTC", 100], ["2017-01-30 11:01:16 UTC", 500]
        ])

      f.yAxis [
        {:title => {:text => "Kilometer", :margin => 70} },
        {:title => {:text => "Kilometer"}, :opposite => true},
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
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

end
