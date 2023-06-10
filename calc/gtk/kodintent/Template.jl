module Template

export do_thatthing_youdo

function do_thatthing_youdo(set_filepath::AbstractString)
    # ANY CODE YOU LIKE - but until then....
    try
        open(set_filepath, "r") do io
            return read(io, String)
        end
    catch
        return "Couldnt read the file contents."
    end
end

end #module