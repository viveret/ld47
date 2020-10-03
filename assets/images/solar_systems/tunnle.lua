stranded.clear_solarsys()

Plr = stranded.get_player()
physics.position( Plr, 0, -400 )

--stranded.next_solarsys( 'rexon_500' )
stranded.solarsys_radius( 512 )

stranded.load_conv( 'After_Landing_On_2nd_Planet' )

stranded.gen_planet( 'sun', 4, -20, -350, 8, 0, 10000 )
stranded.gen_planet( 'sun/sunL', 5, 20, -350, 8, 0, 10000 )

stranded.gen_planet( 'sun/al', 5, -20, -250, 8, 0, 20000 )
stranded.gen_planet( 'sun/ar', 4, 20, -250, 8, 0, 20000 )

stranded.gen_planet( 'sun/bl', 4, -20, -150, 8, 0, 40000 )
stranded.gen_planet( 'sun/br', 5, 20, -150, 8, 0, 40000 )

stranded.gen_planet( 'sun/cl', 5, -20, 0, 8, 0, 100000 )
stranded.gen_planet( 'sun/cr', 4, 20, 0, 8, 0, 100000 )

stranded.gen_planet( 'sun/d', 2, 20, 100, 8, 0, 1000000 )
