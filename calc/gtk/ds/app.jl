#using Pkg
#Pkg.add("Gtk")

using Gtk

function display_ui()::GtkBuilder
    GtkBuilder(filename="help.glade")
end

function run(builder::GtkBuilder)::Channel

    local connectors  = [
        ("quit", "activate", "quit"),
        ("add", "activate", "add"),
        ("dialog", "file-activated", "file"),
        ("dialog", "selection-changed", "file")
    ]

    Channel() do chan
        for (element, event, message) in connectors
            signal_connect(builder[element], event) do widget
                put!(chan, (message, widget))
            end
        end

        local c = Condition()
        signal_connect(builder["main"], :destroy) do widget
            notify(c)
        end
        wait(c)

    end
end

builder = display_ui()
channel = run(builder)

for (msg, widget) in channel
    println("Msg: ", msg)

    if msg == "add"
        showall(builder["dialog"])
    end

    if msg == "file"
        #local filename = Gtk.bytestring(Gtk.GAccessor.filename(widget), true)
        filename = GAccessor.filename(GtkFileChooser(widget))
        if filename != C_NULL
          println("Filename: ", filename)
        end
    end

end