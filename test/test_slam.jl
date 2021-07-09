# module for testing each slam modules

module TestSlam
  using Test
  
  # target modules
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/estimated_object.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/map_particle.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/fast_slam_1/anime_fast_slam_1.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/fast_slam_2/anime_fast_slam_2.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/graph_based_slam/psi_sensor.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/graph_based_slam/traj_obsrv_logger.jl"))
  include(joinpath(split(@__FILE__, "test")[1], "src/slam/graph_based_slam/anime_graph_based_slam.jl"))  

  function main()
    @testset "Slam" begin
      @testset "EstimatedObject" begin
        ep = EstimatedObject(1.0, 2.0, shape=:circle, color=:red,
                             size=5, id=20, cov=[1 1;2 2])
        @test ep.pose == [1.0, 2.0]
        @test ep.id == 20
        @test ep.shape == :circle
        @test ep.color == :red
        @test ep.size == 5
        @test ep.cov == [1 1;2 2]
      end
      @testset "MapParticle" begin
        mp = MapParticle([1.0 2.0 3.0], 0.4, 30)
        @test mp.pose == [1.0 2.0 3.0]
        @test mp.weight == 0.4
        @test mp.object_num == 30
        @test length(mp.map.objects) == 30
      end
      @testset "FastSlam1.0" begin
        @test_nowarn AnimeFastSlam1.main(is_test=true)
      end
      @testset "FastSlam2.0" begin
        @test_nowarn AnimeFastSlam2.main(is_test=true)
      end
      @testset "PsiSensor" begin
        m = Map()
        add_object(m, Object(2.0, -2.0))
        s = PsiSensor(m)
        @test s.last_data == []
        @test s.dist_rng == (0.5, 6.0)
        @test s.dir_rng == (-pi/3, pi/3)
        @test visible(s, [0.5, -pi/3]) == true
        @test visible(s, [6.0, pi/3]) == true
        @test visible(s, [0.2, -pi/3]) == false
        @test visible(s, [0.5, pi]) == false
      end
      @testset "GraphBasedSlam" begin
        @test_nowarn AnimeGraphBasedSlam.main(true)
      end
    end
  end
end