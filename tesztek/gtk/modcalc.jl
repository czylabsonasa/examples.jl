using Gtk

win = GtkWindow("Calculator")

btnsLayout = [
  ["1","2","3","+"],
  ["4","5","6","-"],
  ["7","8","9","x"],
  ["C","0","=","÷"],  
]

btns = GtkButton.(btnsLayout)

hbox = [
  push!(GtkButtonBox(:h), btns[i]...) for i in 1:length()
]

vbox = GtkBox(:v)
label = GtkLabel("")
GAccessor.text(label,"")

push!(vbox, GtkLabel(""))
push!(vbox, label)
push!(vbox, GtkLabel(""))
push!(vbox, hbox[1])
push!(vbox, hbox[2])
push!(vbox, hbox[3])
push!(vbox, hbox[4])
push!(win, vbox)

text = ""

function calculate(s)
	x = "+ " * s
	k = split(x)
	final = 0
	
	for i = 1:length(k)
		
		if k[i] == "+"
			final += parse(Float64, k[i + 1])
		elseif k[i] == "-"
			final -= parse(Float64, k[i + 1])
		elseif k[i] == "x"
			final *= parse(Float64, k[i + 1])
		elseif k[i] == "÷"
			final /= parse(Float64, k[i + 1])
		end
	end
    
	return string(final)
end

is_equal = 0

function button_clicked_callback(widget)
	if widget == b1
        if is_equal == 0
            global text = text * "1"
            GAccessor.text(label, text)
        else
            global text = "1"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b2
    	if is_equal == 0
            global text = text * "2"
            GAccessor.text(label, text)
        else
            global text = "2"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b3
        if is_equal == 0
            global text = text * "3"
            GAccessor.text(label, text)
        else
            global text = "3"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b4
    	if is_equal == 0
            global text = text * "4"
            GAccessor.text(label, text)
        else
            global text = "4"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b5
        if is_equal == 0
            global text = text * "5"
            GAccessor.text(label, text)
        else
            global text = "5"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b6
    	if is_equal == 0
            global text = text * "6"
            GAccessor.text(label, text)
        else
            global text = "6"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b7
        if is_equal == 0
            global text = text * "7"
            GAccessor.text(label, text)
        else
            global text = "7"
            GAccessor.text(label, text)
        end
        global is_equal = 0
    elseif widget == b8
    	if is_equal == 0
            global text = text * "8"
            GAccessor.text(label, text)
        else
            global text = "8"
            GAccessor.text(label, text)
        end
        global is_equal = 0

    elseif widget == b9
        if is_equal == 0
            global text = text * "9"
            GAccessor.text(label, text)
        else
            global text = "9"
            GAccessor.text(label, text)
        end
        global is_equal = 0

    elseif widget == b_plus
    	global text = text * " + "
        GAccessor.text(label, text)
        global is_equal = 0

    elseif widget == b_minus
        global text = text * " - "
        GAccessor.text(label, text)
        global is_equal = 0

    elseif widget == b_multiply
    	global text = text * " x "
        GAccessor.text(label, text)
        global is_equal = 0

    elseif widget == b_divide
        global text = text * " ÷ "
        GAccessor.text(label, text)
        global is_equal = 0

    elseif widget == b0
    	if is_equal == 0
            global text = text * "0"
            GAccessor.text(label, text)
        else
            global text = "0"
            GAccessor.text(label, text)
        end
        global is_equal = 0

    elseif widget == b_clear
        global text = ""
        GAccessor.text(label, text)
        global is_equal = 0

    elseif widget == b_equalto
    	global text = calculate(text)
        global is_equal = 1
        GAccessor.text(label, text)
    end
end

id1 = signal_connect(button_clicked_callback, b1, "clicked")
id2 = signal_connect(button_clicked_callback, b2, "clicked")
id3 = signal_connect(button_clicked_callback, b3, "clicked")
id4 = signal_connect(button_clicked_callback, b4, "clicked")
id5 = signal_connect(button_clicked_callback, b5, "clicked")
id6 = signal_connect(button_clicked_callback, b6, "clicked")
id7 = signal_connect(button_clicked_callback, b7, "clicked")
id8 = signal_connect(button_clicked_callback, b8, "clicked")
id9 = signal_connect(button_clicked_callback, b9, "clicked")
id10 = signal_connect(button_clicked_callback, b0, "clicked")
id11 = signal_connect(button_clicked_callback, b_plus, "clicked")
id12 = signal_connect(button_clicked_callback, b_minus, "clicked")
id13 = signal_connect(button_clicked_callback, b_multiply, "clicked")
id14 = signal_connect(button_clicked_callback, b_divide, "clicked")
id15 = signal_connect(button_clicked_callback, b_clear, "clicked")
id16 = signal_connect(button_clicked_callback, b_equalto, "clicked")

showall(win)
