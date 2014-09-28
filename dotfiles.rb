meta 'dotfiles' do
  accepts_value_for :repo, :basename
  accepts_value_for :target, :basename

  template {
    met? {
      false
    }
    meet {
      if "~/.#{target}".p.exists?
        if "~/.bkp-#{target}".p.exists?
          log_shell "Removing backup", "rm -r ~/.bkp-#{target}"
        end
        log_shell "Backing up the existing ~/.#{target} to ~/.bkp-#{target}", "mv ~/.#{target} ~/.bkp-#{target}"
      end

      if log_shell "Cloning", "git clone https://github.com/jondkinney/#{repo}.git ~/.#{target}"
        log "Symlinking"
        shellout = raw_shell("cd ~/.#{target} && chmod +x install.sh && sh install.sh").stdout
        log "#{shellout}"
      else
        log_shell "Restoring ~/.bkp-#{target} to ~/.#{target}", "mv ~/.bkp-#{target} ~/.#{target}"
      end
    }
  }
end

dep 'dotfiles', :template => 'dotfiles'
dep 'private-dotfiles', :template => 'dotfiles'
