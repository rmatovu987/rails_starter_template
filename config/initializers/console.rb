Rails.application.console do
  # Defines a method to copy the given result to the system clipboard,
  # supporting macOS, Linux (with xclip/xsel), and Windows.
  #
  # @param res [Object] The content to be copied to the clipboard.
  #   It will be converted to a string.
  def copy_to_clipboard(res)
    content_to_copy = res.to_s

    # Determine the operating system and the appropriate clipboard command
    case RbConfig::CONFIG["host_os"]
    when /darwin/ # macOS
      command = "pbcopy"
    when /linux/ # Linux
      # Prioritize xclip, then xsel. User might need to install one of them.
      if system("which xclip > /dev/null 2>&1")
        command = "xclip -selection clipboard"
      elsif system("which xsel > /dev/null 2>&1")
        command = "xsel --clipboard"
      else
        puts "Neither 'xclip' nor 'xsel' found. Please install one for clipboard functionality on Linux."
        puts "  e.g., sudo apt-get install xclip (Debian/Ubuntu) or sudo yum install xclip (Fedora/RHEL)"
        puts "Result (not copied): #{content_to_copy}"
        return
      end
    when /mswin|mingw|windows/ # Windows
      command = "clip" # Built-in command for piping to clipboard
    else
      puts "Unsupported OS for clipboard functionality: #{RbConfig::CONFIG['host_os']}"
      puts "Result (not copied): #{content_to_copy}"
      return
    end

    # Execute the clipboard command
    IO.popen(command, "w") { |io| io.puts content_to_copy }
    puts "Copied to clipboard (#{RbConfig::CONFIG['host_os']})."
  rescue => e
    puts "Error copying to clipboard: #{e.message}"
    puts "Result (not copied): #{content_to_copy}"
  end
end
