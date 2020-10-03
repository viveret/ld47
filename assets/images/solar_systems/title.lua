-- Set boundry to leave solar system
stranded.clear_solarsys()

stranded.next_solarsys( 'rexon_500' )
stranded.solarsys_radius( 512 )

Plr = stranded.get_player()
physics.position( Plr, 0, 10 )

stranded.gen_planet( 'sun', 0, -12, 0, 8, 0, 1500 )
stranded.gen_planet( 'sun/moon1', 5, 12, 0, 8, 0, 1500 )
--stranded.gen_planet( 'sun/Blackhole', -2201, -2200, 1062, 0, 90000 )
