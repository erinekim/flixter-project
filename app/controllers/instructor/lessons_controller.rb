class Instructor::LessonsController < ApplicationController
	before_action :authenticate_user! 
	before_action :require_authorized_for_current_section

	def new
		@lesson = Lesson.new
	end

	def create
	#	@lesson = current_section.lessons.create(lesson_params)
		@lesson = Lesson.new(lesson_params)
		@lesson.section = current_section
		@lesson.save
		redirect_to instructor_course_path(current_section.course)
	end

	private 

	def require_authorized_for_current_section
		if current_section.course.user != current_user
			return render :text => 'Unauthorized', :status => :Unauthorized
		end
	end

	helper_method :current_section
	def current_section
		@current_section ||= Section.find(params[:section_id])
		# if @current_section.present? 
			# return @current_section
		#else 
			# @current_section = Section.find(params[:section_id])
			# return @current_section
		# end 
	end

	def lesson_params
		params.require(:lesson).permit(:title, :subtitle, :video)
	end

end
