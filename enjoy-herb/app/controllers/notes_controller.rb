class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes
  def index
    # Only delay development refetches, never initial HTML or CRUD requests.
    if Rails.env.development? && request.format.symbol == :slots
      sleep ENV.fetch("HERB_SEARCH_DELAY_MS", "800").to_i.clamp(0, 5000) / 1000.0
    end
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to @note, notice: "メモを作成しました。"
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: "メモを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy!
    redirect_to notes_path, notice: "メモを削除しました。", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.expect(note: [ :title, :body ])
    end
end
