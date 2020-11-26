##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vruby'
require 'vr/vrcontrol'

class Form_main < VRForm

  class GroupBox1 < VRGroupbox


    def construct
    end
  end

  def construct
    self.caption = 'BeatSaber Map OneSaber Convert'
    self.move(588,197,740,209)
    addControl(VRRadiobutton,'radioBtn_blue',"Blue",88,104,72,32)
    addControl(VREdit,'edit_inputfile',"",32,32,648,24)
    addControl(VRCheckbox,'checkBox_reverse',"Reverse",160,104,88,32)
    addControl(VRCheckbox,'checkBox_half_obstacles',"half",288,80,120,32)
    addControl(VRCheckbox,'checkBox_squat',"squat modify",288,112,136,32)
    addControl(VRStatic,'static2',"Map Ver",32,64,64,24)
    addControl(VRButton,'button_convert',"Convert",560,104,120,40)
    addControl(VRStatic,'static1',"BeatSaber map file(*.dat)",32,8,192,24)
    addControl(GroupBox1,'groupBox1',"obstacles",264,64,168,88)
    addControl(VRButton,'button_open',"Open",592,56,88,32)
    addControl(VRCheckbox,'checkBox_pretty',"JSON Pretty",440,104,112,32)
    addControl(VRStatic,'static_version',"",96,64,144,24)
    addControl(VRRadiobutton,'radioBtn_red',"Red",32,104,56,32)
  end 

end

##__END_OF_FORMDESIGNER__
