module Fastlane
  module Actions
    # Push local changes to the remote branch
    class PushToGitRemoteAction < Action
      def self.run(params)
        local_branch = params[:local_branch]
        local_branch ||= Actions.git_branch.gsub(%r{#{params[:remote]}\/}, '') if Actions.git_branch
        local_branch ||= 'master'

        remote_branch = params[:remote_branch] || local_branch

        # construct our command as an array of components
        command = [
          'git',
          'push',
          params[:remote],
          "#{local_branch}:#{remote_branch}",
          '--tags'
        ]

        # optionally add the force component
        command << '--force' if params[:force]

        # execute our command
        Actions.sh('pwd')
        return command.join(' ') if Helper.is_test?

        Actions.sh(command.join(' '))
        UI.message('Successfully pushed to remote.')
      end

      def self.description
        "Push local changes to the remote branch"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :local_branch,
                                       env_name: "FL_GIT_PUSH_LOCAL_BRANCH",
                                       description: "The local branch to push from. Defaults to the current branch",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :remote_branch,
                                       env_name: "FL_GIT_PUSH_REMOTE_BRANCH",
                                       description: "The remote branch to push to. Defaults to the local branch",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :force,
                                       env_name: "FL_PUSH_GIT_FORCE",
                                       description: "Force push to remote. Defaults to false",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :remote,
                                       env_name: "FL_GIT_PUSH_REMOTE",
                                       description: "The remote to push to. Defaults to `origin`",
                                       default_value: 'origin')
        ]
      end

      def self.author
        "lmirosevic"
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
