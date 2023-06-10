include("./Template.jl") #relative path for a paired module
using .Template

using Gtk
using Dates

# CREATE THE GUI WIDGETS
text_info = "Template for a simple Julia GUI app. Modify it as needed.\nThis example fetches the content of a file and displays it in the textview below."
textlabel_info = GtkLabel(text_info)
set_gtk_property!(textlabel_info, :xalign, 0.5) # centers first line

button_setfile = GtkButton("Set File")
path_file = GtkEntry()
set_gtk_property!(path_file, :xalign, 1.0) # 0-1 balrol jobbra

button_start_idle_text = "Show File Content"
button_start = GtkButton(button_start_idle_text)
textlabel_progress = GtkLabel("")
set_gtk_property!(textlabel_progress, :xalign, 0.1)

textbuffer_results = GtkTextBuffer() # access point for text
textview = GtkTextView(textbuffer_results) # buffer inside textview
scrolledwindow = GtkScrolledWindow(textview) # textview inside scrolledwindow
set_gtk_property!(scrolledwindow, :min_content_height, 100)
set_gtk_property!(textview, :wrap_mode, 2)
set_gtk_property!(textview, :left_margin, 5)

# CREATE A GRID AND ARRANGE WIDGETS
grid = GtkGrid()
set_gtk_property!(grid, :column_homogeneous, true)
#set_gtk_property!(grid, :row_homogeneous, true)

grid[1:5,1] = textlabel_info
grid[1,2] = button_setfile 
grid[2:5,2] = path_file 
grid[1,3] = button_start 
grid[2:5,3] = textlabel_progress 
grid[1:5,4] = scrolledwindow 

# CREATE THE WINDOW AND ADD THE GRID
window = GtkWindow("Window Title", 1000, 300)
set_gtk_property!(window, :resizable, true)
push!(window, grid)
showall(window)

# RESPOND TO BUTTON CLICKS AND EVENTS
button_setfile_triggered = signal_connect(button_setfile, "clicked") do widget
    selected_filepath = open_dialog("SELECT FILE...")
    if selected_filepath !== nothing
        set_gtk_property!(path_file, :text, selected_filepath)
        set_gtk_property!(textlabel_progress, :label, "")
        set_gtk_property!(textbuffer_results, :text, "")
    end
end

button_start_triggered = signal_connect(button_start, "clicked") do widget
    set_filepath = get_gtk_property(path_file,:text,String)
    # VALIDITY CHECKS
    if get_gtk_property(button_start, :label, String) != button_start_idle_text
        set_gtk_property!(textlabel_progress, :label, "I'm busy")
    elseif set_filepath == "" || !isfile(set_filepath)
        set_gtk_property!(textlabel_progress, :label, "Select file.")
    else
        time_script_start = now()
        set_gtk_property!(button_start, :label, "Doing it...")

        # SEND WORK TO THE MODULE FUNCTION
        result_string = Template.do_thatthing_youdo(set_filepath)

        set_gtk_property!(textbuffer_results, :text, result_string)
        set_gtk_property!(button_start, :label, button_start_idle_text)
        # OPTIONAL TIMING STATS
        duration_script_s = Dates.value(now()-time_script_start)/1000
        if duration_script_s < 60
            duration_script_m = round(duration_script_s, sigdigits=3)
            set_gtk_property!(textlabel_progress, :label, "I did it in $duration_script_s sec")
        else
            duration_script_m = round(duration_script_s / 60, sigdigits=3)
            set_gtk_property!(textlabel_progress, :label, "I did it in $duration_script_m min")
        end
    end
end

# condition keeps window open, unless closed by user.
if !isinteractive()
    c = Condition()
    signal_connect(window, :destroy) do widget
        notify(c)
    end
    wait(c)
end

#Module. A simple paired module for holding the code that does all the work.

