meta 'dotfiles' do
  accepts_value_for :repo, :basename
  accepts_value_for :target, :basename

  template {
    met? { 
      if "~/.j2fly-#{target}/installed_successfully".p.exists?
        log "There is already a ~/.j2fly-dotfiles installation in place."
        log "Remove the ~/.j2fly-dotfiles/installed_successfully file and re-run to install again"
        true
      else
        false
      end  
    }
    meet {
      if "~/.j2fly-#{target}".p.exists?
        if "~/.bkp-j2fly-dotfiles".p.exists?
          log_shell "Removing backup", "sudo rm -r ~/.bkp-j2fly-dotfiles"
        end
        log_shell "Backing up the existing ~/.j2fly-dotfiles to ~/.bkp-j2fly-dotfiles", "mv ~/.j2fly-dotfiles ~/.bkp-j2fly-dotfiles"
      end
      
      if log_shell "Cloning", "git clone https://github.com/j2fly/#{repo}.git /Users/`whoami`/.j2fly-#{target}"
        log "Symlinking"
        shellout = raw_shell("cd /Users/`whoami`/.j2fly-#{target}/tools && sh install.sh").stdout
        log "#{shellout}"
      else
        log_shell "Restoring ~/.bkp-j2fly-dotfiles to ~/.j2fly-dotfiles", "mv ~/.bkp-j2fly-dotfiles ~/.j2fly-dotfiles"
      end
    }
  }
end

dep 'dotfiles', :template => 'dotfiles'
# dep 'private-dotfiles', :template => 'dotfiles'