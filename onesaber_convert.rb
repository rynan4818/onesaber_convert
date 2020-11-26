#! ruby -Ks
require 'vr/vruby'
require '_frm_onesaber_convert'
require 'rubygems'
require 'json'

class Form_main                                                     ##__BY_FDVR

  def self_created
    @map_data = {}
    @ext_list = [["BeatSaber Map(*.dat)","*.dat"],["all file (*.*)","*.*"]]
    @radioBtn_blue.check(true)
  end

  def button_open_clicked
    map_file = SWin::CommonDialog::openFilename(self,@ext_list,0x1004,'Map file select','*.dat')
    return unless map_file
    return unless File.exist?(map_file)
    @edit_inputfile.text = map_file
    @map_data = JSON.parse(File.read(@edit_inputfile.text))
    @static_version.caption = @map_data["_version"]
  end

  def button_convert_clicked
    unless File.exist?(@edit_inputfile.text)
      messageBox("BeatSaber Map file select!","Input file select!",48)
      return
    end
    fn = SWin::CommonDialog::saveFilename(self,@ext_list,0x1004,'Convert map file','*.dat')
    return unless fn
    if File.exist?(fn)
      return unless messageBox("Do you want to overwrite?","Overwrite confirmation",0x0004) == 6
    end
    @map_data = JSON.parse(File.read(@edit_inputfile.text))
    @static_version.caption = @map_data["_version"]
    notes = []
    @map_data['_notes'].each do |a|
      if (@radioBtn_red.checked? && a["_type"] == 0) || (@radioBtn_blue.checked? && a["_type"] == 1)
        type = 1
        line_layer = a["_lineLayer"]
        if @checkBox_reverse.checked?
          line_index = (a["_lineIndex"] - 3).abs
          case a["_cutDirection"]
          when 2
            cut_direction = 3
          when 3
            cut_direction = 2
          when 4
            cut_direction = 5
          when 5
            cut_direction = 4
          when 6
            cut_direction = 7
          when 7
            cut_direction = 6
          else
            cut_direction = a["_cutDirection"]
          end
        else
          line_index = a["_lineIndex"]
          cut_direction = a["_cutDirection"]
        end
        push_notes = { "_time" => a["_time"],
                     "_lineIndex" => line_index,
                     "_lineLayer" => line_layer,
                     "_type" => type,
                     "_cutDirection" => cut_direction}
        notes.push push_notes
      end
      if a["_type"] == 3
        type = 3
        line_layer = a["_lineLayer"]
        cut_direction = a["_cutDirection"]
        if @checkBox_reverse.checked?
          line_index = (a["_lineIndex"] - 3).abs
        else
          line_index = a["_lineIndex"]
        end
        push_notes = { "_time" => a["_time"],
                     "_lineIndex" => line_index,
                     "_lineLayer" => line_layer,
                     "_type" => type,
                     "_cutDirection" => cut_direction}
        notes.push push_notes
      end
    end
    @map_data['_notes'] = notes

    obstacles = []
    @map_data['_obstacles'].each do |a|
      push_flag = true
      type = a["_type"]
      duration = a["_duration"]
      width = a["_width"]
      line_index = a["_lineIndex"]
      if @checkBox_reverse.checked?
        case width
        when 1
          line_index = (line_index - 3).abs
        when 2
          #0→2
          #1→1
          #2→0
          #3→null
          if line_index < 3
            line_index = (line_index - 2).abs
          else
            messageBox("obstacles time #{a["_time"]} line index #{a["_lineIndex"]}","obstacles ERROR",48)
            return
          end
        when 3
          #0→1
          #1→0
          #2→null
          #3→null
          if line_index < 2
            line_index = (line_index - 1).abs
          else
            messageBox("obstacles time #{a["_time"]} line index #{a["_lineIndex"]}","obstacles ERROR",48)
            return
          end
        when 4
        else
          messageBox("obstacles time #{a["_time"]} line index #{a["_lineIndex"]}","obstacles ERROR",48)
          return
        end
      end
      if @checkBox_half_obstacles.checked?
        if (@radioBtn_red.checked? && @checkBox_reverse.checked?) || (@radioBtn_blue.checked? && (not @checkBox_reverse.checked?))
          #右 (左半分の壁を消す)
          if (line_index + width) <= 2
            push_flag = false
          else
            case line_index
            when 0
              width -= 2
              line_index = 2
            when 1
              width -= 1
              line_index = 2
            end
          end
          if type == 1 && @checkBox_squat.checked?
            #しゃがむ壁の時、lineIndex=1～2に壁がある場合はlineIndex=0と1もしゃがむ壁にする
            check_line = []
            a["_width"].times {|b| check_line[b + a["_lineIndex"]] = true }
            if check_line[1] && check_line[2]
              push_flag = true
              line_index = 0
              if check_line[3]
                width = 4
              else
                width = 3
              end
            end
          end
        else
          #左 (右半分の壁を消す)
          if (line_index + width) > 2
            case line_index
            when 0
              width = 2
            when 1
              width = 1
            else
              push_flag = false
            end
          end
          if type == 1 && @checkBox_squat.checked?
            #しゃがむ壁の時、lineIndex=1～2に壁がある場合にlineIndex=2と3もしゃがむ壁にする。
            check_line = []
            a["_width"].times {|b| check_line[b + a["_lineIndex"]] = true }
            if check_line[1] && check_line[2]
              push_flag = true
              if check_line[0]
                line_index = 0
                width = 4
              else
                line_index = 1
                width = 3
              end
            end
          end
        end
      end
      if push_flag
        push_obstacles = { "_time" => a["_time"],
                     "_lineIndex" => line_index,
                     "_type" => type,
                     "_duration" => duration,
                     "_width" => width}
        obstacles.push push_obstacles
      end
    end
    @map_data['_obstacles'] = obstacles
    File.open(fn,'w') do |file|
      if @checkBox_pretty.checked?
        JSON.pretty_generate(@map_data).each do |line|
          file.puts line
        end
      else
        JSON.generate(@map_data).each do |line|
          file.puts line
        end
      end
    end
  end
end                                                                 ##__BY_FDVR

VRLocalScreen.start Form_main

=begin
###メモ###

#notes#
_lineIndex
0123
_lineLayer
2
1
0
_cutDirection
0:↑(180deg)
1:↓(0deg)
2:←(90deg)
3:→(270deg)
4:↑←(135deg)
5:↑→(225deg)
6:↓←(45deg)
7:↓→(315deg)
8:dot
_type
0:red
1:blue
2:N/A
3:bom

#obstacles#
lineIndex：壁の発生ポイント
type：0は横、1はしゃがんで避ける
duration：長さ(画面上は奥行き)
width：壁の幅
=end
