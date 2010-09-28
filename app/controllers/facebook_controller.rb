class FacebookController < ApplicationController
  def index
    
    #Testing
    # session["id"] = "1115105088"

    @user = User.find_by_facebookid(session["id"])
    
    if @user
     
      friends = RestClient.get "https://graph.facebook.com/me/friends", {:params => {:access_token => @user.token}}

      if friends.body
        data = friends.body
        @friends = JSON.parse(data)
      end
      
    end 
    
  end

  def show
  end
  
  def phono
    # format DID or SIP address properly
    phone = params[:id] 
    if phone
      phone = phone.gsub("-", "").gsub("(", "").gsub(")", "").gsub("+", "")
      if phone.index("@") and !phone.index("sip:")
        phone = "sip:" + phone
      end
  
      if isNumeric(phone) and phone.length == 10
        phone = "1" + phone
      end
    
      #Setup Dial (DID or SIP) | http://phono.com/16025551212
      if isNumeric(phone) 
        @did = phone
        # @phone = "sip:9991443313@sip.tropo.com" #;postd=p16025551212;pause=1000ms
        # @phone = "sip:9991443313@stagingsbc-external.orl.voxeo.net"
        # @phone = "sip:9991443313@sbcexternal.orl.voxeo.net"
        @phone = "app:9991443313"
      
      elsif phone.index('@') or phone.index('app:')
        @did = ""
        @phone = phone
    
      else
        # @did = "app:9991443124"
        # @phone = "app:9991443124"
        # @short = @phone
      
      end
    end
    
    render :layout => false
    
  end

end
