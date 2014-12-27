class Instructor::LessonsController < ApplicationController
	before_action :authenticate_user! 
	before_action :require_authorized_for_current_section, :only => [:new, :create]
	before_action :require_authorized_for_current_lesson, :only => [:update]

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

	def update
		if current_lesson.update_attributes(lesson_params)
			render :text => 'updated!'
		end
	end

	private 

	def require_authorized_for_current_lesson
		if current_lesson.section.course.user != current_user
			render :text => 'Unauthorized', :status => :unauthorized
		end
	end

	def current_lesson
		@current_lesson ||= Lesson.find(params[:id])
	end

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
		params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
	end

end
