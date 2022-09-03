# 描画関係

class Viewer
  def initialize
    @back_img = Image.new(800, 800, C_BLUE)
    @back = Sprite.new(0, 0, @back_img)
    @fie_img = Image.new(400, 400, C_GREEN)
    @field = Sprite.new(10, 10, @fie_img)
    @dat_img = Image.new(150, 100, C_YELLOW)
    @data = Sprite.new(450, 110, @dat_img)
    @button_img = Image.new(150, 50, C_RED)
    @n_g_button = Sprite.new(450, 280, @button_img)
    @end_button = Sprite.new(450, 350, @button_img)
    @start_button = Sprite.new(250, 200, @button_img)
    @font = Font.new(32)
    @font2 = Font.new(40)
    @font3 = Font.new(90)
    @black_line = []
    @color_stone = [C_BLACK, C_WHITE]

    
    9.times do |i|
      @black_line << Sprite.new(i * 50  + 10 , 10, Image.new(3, 400, C_BLACK))
    end
    9.times do |i|
      @black_line << Sprite.new(10 , i * 50 + 10, Image.new(400, 3, C_BLACK))
    end
  end

  def draw
    #ターンの石
    stone_img = Image.new(46, 46).circle_fill(23, 23, 23, @color_stone[$turn % 2])
    turn_stone = Sprite.new(310, 415, stone_img)
    
    #石をスプライト化
    stone = []
    8.times do |i|
      8.times do |j|
        if $map[i][j] != 0
          stone << Sprite.new((i) * 50  + 13.5, (j) * 50 + 13.5, Image.new(46, 46).circle_fill(23, 23, 23, @color_stone[$map[i][j] - 1]))
        end
      end
    end

    #描画
    @back.draw
    if $opening == 1
      @field.draw
      turn_stone.draw
      @data.draw
      @end_button.draw
      @n_g_button.draw
      Sprite.draw(@black_line)
      Sprite.draw(stone)
      Window.draw_font(10, 410, "TURN #{$turn - $path_turn}/60", @font)
      Window.draw_font(450, 110, "黒  #{$n_o_stone[0]}石", @font)
      Window.draw_font(450, 150, "白  #{$n_o_stone[1]}石", @font)
      Window.draw_font(360, 420, "番", @font)
      Window.draw_font(450, 285, "New Game", @font)
      Window.draw_font(500, 355, "End", @font)
    else
      @start_button.draw
      Window.draw_font(270, 205, "Start", @font2)
      Window.draw_font(120, 100, "OTHELLO", @font3)
    end
  end
end
