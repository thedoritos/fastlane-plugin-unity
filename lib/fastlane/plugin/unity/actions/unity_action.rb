require 'fastlane/action'
require_relative '../helper/unity_helper'

module Fastlane
  module Actions
    class UnityAction < Action
      def self.run(params)
        build_cmd = "#{params[:executable]}"
        build_cmd << " -projectPath \"#{params[:project_path]}\"" unless params[:project_path].nil?
        build_cmd << " -quit" if params[:quit]
        build_cmd << " -batchmode" if params[:batchmode]
        build_cmd << " -executeMethod \"#{params[:execute_method]}\"" unless params[:execute_method].nil?
        build_cmd << " -username \"#{params[:username]}\"" unless params[:username].nil?
        build_cmd << " -password \"#{params[:password]}\"" unless params[:password].nil?
        build_cmd << " -logfile"

        # Must be the last option
        build_cmd << " &" if params[:background]

        UI.message ""
        UI.message Terminal::Table.new(
          title: "Unity".green,
          headings: ["Option", "Value"],
          rows: params.values
        )
        UI.message ""

        UI.message "Start running"
        UI.message ""

        sh build_cmd

        UI.success "Finished"
      end

      def self.description
        "Run Unity"
      end

      def self.authors
        ["thedoritos"]
      end

      def self.return_value

      end

      def self.details
        "Run Unity command with options"
      end

      def self.available_options
        # See the document for usage.
        # https://docs.unity3d.com/Manual/CommandLineArguments.html
        [
          FastlaneCore::ConfigItem.new(key: :executable,
                                  env_name: "FL_UNITY_EXECUTABLE",
                               description: "Path to Unity executable",
                             default_value: "/Applications/Unity/Unity.app/Contents/MacOS/Unity"),

          FastlaneCore::ConfigItem.new(key: :batchmode,
                                  env_name: "FL_UNITY_BATCHMODE",
                               description: "Should run command in batch mode",
                             default_value: false,
                                 is_string: false),

          FastlaneCore::ConfigItem.new(key: :project_path,
                                  env_name: "FL_UNITY_PROJECT_PATH",
                               description: "Path to Unity project",
                             default_value: "#{Dir.pwd}",
                                  optional: true),

          FastlaneCore::ConfigItem.new(key: :quit,
                                  env_name: "FL_UNITY_QUIT",
                               description: "Should quit Unity after execution",
                             default_value: false,
                                 is_string: false),

          FastlaneCore::ConfigItem.new(key: :execute_method,
                                  env_name: "FL_UNITY_EXECUTE_METHOD",
                               description: "Method to execute",
                                  optional: true),

          FastlaneCore::ConfigItem.new(key: :username,
                                  env_name: "FL_UNITY_USERNAME",
                               description: "User name for log-in",
                                  optional: true),

          FastlaneCore::ConfigItem.new(key: :password,
                                  env_name: "FL_UNITY_PASSWORD",
                               description: "Password for log-in",
                                  optional: true),

          FastlaneCore::ConfigItem.new(key: :background,
                                  env_name: "FL_UNITY_BACKGROUND",
                               description: "Should run command in background (adding &)",
                             default_value: false,
                                 is_string: false)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
