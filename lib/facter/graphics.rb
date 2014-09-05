# has_nvidia_graphics.rb
#

if Facter.value('kernel') == "Linux"
    lspci = %x{which lspci}.chomp
    #exit 0 if $?.existatus != 0
    graphics = "false"
    if lspci.length > 0 and lspci = %x{#{lspci}}
        if vga_full = lspci.match(/VGA.*/)
            vga_full = vga_full[0].split(/:/)[1].lstrip
            Facter.add("graphics_full") do
                setcode do
                    vga_full
                end # setcode
            end
            if ! gmatch = vga_full.match(/(\S+)\s(.*)\s\(.*\)$/)
                gmatch = vga_full.match(/(\S+)\s(.*)$/)
            end
            graphics = gmatch[1].downcase
            model_tmp = gmatch[2]

            if model = model_tmp[/\[(.+)\]/]
                model = model[1..model.length-2]
            elsif model = model_tmp.match(/[Corporation|Technologies]\s(.*)$/)
                model = model[1]
                model.gsub!(/^Inc\s/, '')
            end
            if defined? model and ! model.nil?
                Facter.add("graphics_model") do
                    setcode do
                        model
                    end # setcode
                end
            end
        end
    end
    ### add the graphics fact
    Facter.add("graphics") do
        setcode do
            graphics
        end # setcode
    end
elsif Facter.value('kernel') == "Darwin"
    graphics = %x{system_profiler SPDisplaysDataType }
    Facter.add("graphics") do
        setcode do
            if ( graphics.match /Vendor: ATI/ )
                "ati"
            elsif ( graphics.match /Vendor: NVIDIA/ )
                "nvidia"
            else
                "false"
            end
        end
    end
    Facter.add("graphics_full") do
        setcode do
            graphics.match(/^\s+(.*):$/)[1]
        end
    end
    Facter.add("graphics_model") do
        setcode do
            graphics.match(/^\s+\S+\s(.*):$/)[1]
        end
    end
end
