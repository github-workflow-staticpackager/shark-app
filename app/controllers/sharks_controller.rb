class SharksController < ApplicationController
  before_action :set_shark, only: %i[ show edit update destroy ]

  # GET /sharks or /sharks.json
  def index
    @sharks = Shark.all
  end

  # GET /sharks/1 or /sharks/1.json
  def show
  end

  # GET /sharks/new
  def new
    @shark = Shark.new
  end

  # GET /sharks/1/edit
  def edit
  end

  # POST /sharks or /sharks.json
  def create
    @shark = Shark.new(shark_params)

    respond_to do |format|
      if @shark.save
        format.html { redirect_to shark_url(@shark), notice: "Shark was successfully created." }
        format.json { render :show, status: :created, location: @shark }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shark.errors, status: :unprocessable_entity }
      end
    end

    # Call to our testcase code
    testcase
  
  end

  # PATCH/PUT /sharks/1 or /sharks/1.json
  def update
    respond_to do |format|
      if @shark.update(shark_params)
        format.html { redirect_to shark_url(@shark), notice: "Shark was successfully updated." }
        format.json { render :show, status: :ok, location: @shark }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sharks/1 or /sharks/1.json
  def destroy
    @shark.destroy

    respond_to do |format|
      format.html { redirect_to sharks_url, notice: "Shark was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Testcase for CWE 78
  def testcase
    tainted = shark_params[:name]
    mySafeString = "I am a safe shark"
    myUnsafeString = "#{mySafeString} #{tainted}"

    print(system("echo 'A new shark appears! Welcome #{tainted}'")) # CWEID 78
    print(system(tainted)) # CWEID 78
    print(system("echo Hello new sharks!")) # FP
    print(system(mySafeString)) # FP
    print(system("#{mySafeString}")) # FP
    print(system("#{tainted}")) # CWE 78
    print(system(myUnsafeString)) # CWE 78
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shark
      @shark = Shark.find(params[:id]) # CWE 89
    end

    # Only allow a list of trusted parameters through.
    def shark_params
      params.require(:shark).permit(:name, :facts)
    end
end
