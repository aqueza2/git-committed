require 'will_paginate/array'
class ProfilesController < ApplicationController
  before_action :load_preference_data, only: [:edit]
  def index
    if current_user
      filtered = Profile.order(updated_at: :desc).where.not(id: current_user.profile.id).select {|profile| fits_filter(profile)}
      @profiles = filtered.shuffle.paginate(:per_page => 10)
    else
      redirect_to login_path
    end
  end

  def show
    @profile = Profile.find_by(id: params[:id])
    if @profile
      @user = @profile.user
    else
      redirect_to login_path #change to 404 page path
    end
  end

  def edit
    @profile = Profile.find_by(id: params[:id])
    if @profile != current_user.profile
      redirect_to edit_profile_path(current_user.profile)
    end

    @user = current_user
    @user_languages = @user.languages
    @user_skills = @user.skills

    @maximum_length = Profile.validators_on(:about_me).first.options[:maximum]
    @current_length = @maximum_length - @user.profile.about_me.length
    # if @user.profile.about_me != nil
    #   @current_length = @maximum_length - @user.profile.about_me.length
    # else
    #   @current_length = @maximum_length
    # end

  end

  def update
    @user = User.find(current_user.id)
    ProfileUpdater.new.call(@user, params)
    redirect_to profile_path(@user.profile)
 end

  private

  def load_preference_data
    @genders = Gender.all
    @programming_languages = Language.all
    @text_editors = TextEditor.all
    @operating_systems = OperatingSystem.all
    @skills = Skill.all
    @relationship_types = RelationshipType.all
    @sexual_preferences = SexualPreference.all
    @sexual_orientations = SexualOrientation.all
  end

  def fits_filter(profile)
    return profile if get_user_filters.any? {|det| profile.get_traits.include?(det)}
  end
end
