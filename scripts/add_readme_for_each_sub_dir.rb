# Script: add_readme_for_each_sub_dir.rb
# Purpose: create missing README.md files for subdirectories under
# the major sections C, D and E (Backend Infrastructure, Networking & Security,
# Development Process & Teamwork). The logic below scans the repository
# structure, builds a consistent README for each subdir (listing topic md files)
# and writes it only if it does not already exist.

require 'fileutils'

REPO_ROOT = File.expand_path('..', __dir__)

# Explicit target major directories (as used in this repo)
TARGET_MAJORS = [
	'C_Backend_Infrastructure',
	'D_Networking_and_Security',
	'E_Development_Process_and_Teamwork'
]

def human_title(dir_name)
	# If name starts with a numeric prefix like "1_Programming_Foundations"
	# produce "1 — Programming Foundations" to match existing style.
	if dir_name =~ /^(\d+)[_\-](.+)$/
		num = $1
		rest = $2.gsub(/[_\-]+/, ' ').strip
		"#{num} — #{rest}"
	else
		dir_name.gsub(/[_\-]+/, ' ').strip
	end
end

def gather_topic_md(subdir_path)
	Dir.children(subdir_path)
		 .select { |f| f.downcase.end_with?('.md') }
		 .reject { |f| f.downcase == 'readme.md' }
		 .sort
end

def build_readme_content(subdir_name, topics)
	title = human_title(subdir_name)
	lines = []
	lines << "# #{title}"
	lines << ""
	lines << "Topics:"
	lines << ""
	if topics.empty?
		lines << "(no topic files found)"
	else
		topics.each do |t|
			# keep link text consistent with other READMEs (filename.md)
			lines << "- [#{t}](#{t})"
		end
	end
	lines << ""
	lines << "TODO: add study plan, resources and exercises for each topic."
	lines.join("\n") + "\n"
end

created = []

TARGET_MAJORS.each do |major|
	major_path = File.join(REPO_ROOT, major)
	next unless Dir.exist?(major_path)

	Dir.children(major_path).each do |subdir|
		subdir_path = File.join(major_path, subdir)
		next unless File.directory?(subdir_path)

		readme_path = File.join(subdir_path, 'README.md')
		if File.exist?(readme_path)
			# already has README — keep it unchanged
			next
		end

		topics = gather_topic_md(subdir_path)
		content = build_readme_content(subdir, topics)

		# Write README.md for the subdirectory
		File.open(readme_path, 'w') do |f|
			f.write(content)
		end
		created << readme_path
		puts "Created: #{readme_path}"
	end
end

puts "Done. Created #{created.count} README(s)." unless created.empty?
