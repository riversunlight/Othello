require 'dxruby'

#いろいろ初期化
back_img = Image.new(800, 800, C_BLUE)
back = Sprite.new(0, 0, back_img)
fie_img = Image.new(400, 400, C_GREEN)
field = Sprite.new(10, 10, fie_img)
dat_img = Image.new(150, 100, C_YELLOW)
data = Sprite.new(450, 110, dat_img)
button_img = Image.new(150, 50, C_RED)
n_g_button = Sprite.new(450, 280, button_img)
end_button = Sprite.new(450, 350, button_img)
start_button = Sprite.new(250, 200, button_img)
opening = 0
game_end = 0
font = Font.new(32)
font2 = Font.new(40)
font3 = Font.new(90)
$n_o_stone = [2,2]
black_line = []
9.times do |i|
  black_line << Sprite.new(i * 50  + 10 , 10, Image.new(3, 400, C_BLACK))
end
9.times do |i|
  black_line << Sprite.new(10 , i * 50 + 10, Image.new(400, 3, C_BLACK))
end

$map = []
8.times do
  kari_array = []
  8.times do
    kari_array.push(0)
  end
  $map.push(kari_array)
end

stone = []
$map[5 - 1][4 - 1] = 1
$map[4 - 1][5 - 1] = 1
$map[4 - 1][4 - 1] = 2
$map[5 - 1][5 - 1] = 2

color_stone = [C_BLACK, C_WHITE]
$turn = 0
$path_turn = 0
$path_flag = 0

def path?
  flag = 0
  dire = [
    [1, 1, 0, -1, -1, -1, 0, 1],
    [0, 1, 1, 1, 0, -1, -1, -1]
  ]
  8.times do |k|
    8.times do |j|
      8.times do |i|
        oth_sto = ($turn % 2 == 0) ? 2 : 1
        if k + dire[0][i] >= 0 && k + dire[0][i] < 8 && j + dire[1][i] >= 0 && j + dire[1][i] < 8 && $map[k][j] == 0
          if $map[k + dire[0][i]][j + dire[1][i]] == oth_sto
            c_x = k + dire[0][i]
            c_y = j + dire[1][i]
            while c_x >= 0 && c_x < 8 && c_y >= 0 && c_y < 8
              if ($map[c_x][c_y] != oth_sto)
                if ($map[c_x][c_y] == 0 || k < 0 || k >= 8 || j < 0 || j >= 8)
                  break
                else
                  flag = 1
                  break
                end
              end
              c_x += dire[0][i]
              c_y += dire[1][i]
            end
          end
        end
      end
      if (flag == 1)
        return true
      end
    end
  end

  return false
end

#石をひっくり返す&ひっくりかえせるか判断
def reverse_stone(x, y)
  flag = 0
  dire = [
    [1, 1, 0, -1, -1, -1, 0, 1],
    [0, 1, 1, 1, 0, -1, -1, -1]
  ]

  8.times do |i|
    oth_sto = ($turn % 2 == 0) ? 2 : 1
    if x + dire[0][i] >= 0 && x + dire[0][i] < 8 && y + dire[1][i] >= 0 && y + dire[1][i] < 8
      if $map[x + dire[0][i]][y + dire[1][i]] == oth_sto
        reveres = []
        c_x = x + dire[0][i]
        c_y = y + dire[1][i]
        fla_rev = 0
        while c_x >= 0 && c_x < 8 && c_y >= 0 && c_y < 8
          if ($map[c_x][c_y] != oth_sto)
            if ($map[c_x][c_y] == 0 || x < 0 || x >= 8 || y < 0 || y >= 8)
              break
            else
              fla_rev = 1
              flag = 1
              break
            end
          end
          reveres.push([c_x, c_y])
          c_x += dire[0][i]
          c_y += dire[1][i]
        end
        if fla_rev == 1
          $n_o_stone[$turn % 2] += reveres.size
          $n_o_stone[1 - $turn % 2] -= reveres.size
          reveres.size.times do |i|
            $map[reveres[i][0]][reveres[i][1]] = $turn % 2 + 1
          end
        end
      end
    end
  end
  return flag
end

Window.loop do

  #ターンの石
  stone_img = Image.new(46, 46).circle_fill(23, 23, 23, color_stone[$turn % 2])
  turn_stone = Sprite.new(310, 415, stone_img)

  #石の設置
  if path? || game_end == 1
    if Input.mouse_push?(M_LBUTTON)
      a_img = Image.new(1, 1, C_WHITE)
      m = Sprite.new(Input.mouse_pos_x, Input.mouse_pos_y, a_img)
      if opening == 1
        x = (Input.mouse_pos_x - 10) / 50
        y = (Input.mouse_pos_y - 10) / 50
        if (x >= 0 && x < 8 && y >= 0 && y < 8 && $map[x][y] == 0)
          flag = reverse_stone(x, y)
          if (flag == 1)
            $map[x][y] = $turn % 2 + 1
            $n_o_stone[$turn % 2] += 1
            $turn += 1
          end
        elsif m === end_button
          $n_o_stone = [2, 2]
          game_end = 0
          $path_flag = 0
          $path_turn = 0
          $turn = 0
          $map = []
          8.times do |i|
            k_array = []
            8.times do |j|
              k_array.push(0)
            end
            $map.push(k_array)
          end
          $map[5 - 1][4 - 1] = 1
          $map[4 - 1][5 - 1] = 1
          $map[5 - 1][5 - 1] = 2
          $map[4 - 1][4 - 1] = 2
          opening = 0
        elsif m === n_g_button
          $n_o_stone = [2, 2]
          game_end = 0
          $path_flag = 0
          $path_turn = 0
          $turn = 0
          $map = []
          8.times do |i|
            k_array = []
            8.times do |j|
              k_array.push(0)
            end
            $map.push(k_array)
          end
          $map[5 - 1][4 - 1] = 1
          $map[4 - 1][5 - 1] = 1
          $map[5 - 1][5 - 1] = 2
          $map[4 - 1][4 - 1] = 2
        end
      else
        if m === start_button
          opening = 1
        end
      end
    end
    $path_flag = 0
  else
    $turn += 1
    $path_turn += 1
    $path_flag += 1
  end
  
  #石をスプライト化
  stone = []
  8.times do |i|
    8.times do |j|
      if $map[i][j] != 0
        stone << Sprite.new((i) * 50  + 13.5, (j) * 50 + 13.5, Image.new(46, 46).circle_fill(23, 23, 23, color_stone[$map[i][j] - 1]))
      end
    end
  end

  #描画
  back.draw
  if opening == 1
    field.draw
    turn_stone.draw
    data.draw
    end_button.draw
    n_g_button.draw
    Sprite.draw(black_line)
    Sprite.draw(stone)
    Window.draw_font(10, 410, "TURN #{$turn - $path_turn}/60", font)
    Window.draw_font(450, 110, "黒  #{$n_o_stone[0]}石", font)
    Window.draw_font(450, 150, "白  #{$n_o_stone[1]}石", font)
    Window.draw_font(360, 420, "番", font)
    Window.draw_font(450, 285, "New Game", font)
    Window.draw_font(500, 355, "End", font)
  else
    start_button.draw
    Window.draw_font(270, 205, "Start", font2)
    Window.draw_font(120, 100, "OTHELLO", font3)
  end

  #勝敗判定
  if $turn - $path_turn == 60 || $path_flag == 2
    if $n_o_stone[0] > $n_o_stone[1]
      Window.draw_font(420, 430, "BLACK WIN!", font2)
    elsif $n_o_stone[1] > $n_o_stone[0]
      Window.draw_font(420, 430, "WHITE WIN!", font2)
    else
      Window.draw_font(420, 430, "DRAW", font2)
    end
    game_end = 1
  end

  if $n_o_stone[0] == 0
    Window.draw_font(420, 430, "WHITE WIN!", font2)
    game_end = 1
  elsif $n_o_stone[1] == 0
    Window.draw_font(420, 430, "BLACK WIN!", font2)
    game_end = 1
  end
end