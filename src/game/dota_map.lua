--Get positions with `dota_camera_get_lookatpos` which returns the position the camera is looking at
local map = {

  rune = {
    bounty = {
      radiant_primary = {
        id = RUNE_BOUNTY_1,
        location = GetRuneSpawnLocation(RUNE_BOUNTY_1)
      },
      radiant_secondary = {
        id = RUNE_BOUNTY_2,
        location = GetRuneSpawnLocation(RUNE_BOUNTY_2)
      },
      dire_primary = {
        id = RUNE_BOUNTY_3,
        location = GetRuneSpawnLocation(RUNE_BOUNTY_3)
      },
      dire_secondary = {
        id = RUNE_BOUNTY_4,
        location = GetRuneSpawnLocation(RUNE_BOUNTY_4)
      }
    },
    power = {
      top = {
        id = RUNE_POWERUP_1,
        location = GetRuneSpawnLocation(RUNE_POWERUP_1)
      },
      bottom = {
        id = RUNE_POWERUP_2,
        location = GetRuneSpawnLocation(RUNE_POWERUP_2)
      }
    }
  },

  jungle = {
    radiant_primary = {
      {
        boundary = {
          Vector(-2192.562744, -3768.654785, 278.637390),
          Vector(-1442.738159, -3767.494385, 267.677673),
          Vector(-1451.903809, -4654.895020, 293.377808),
          Vector(-2210.875000, -4697.000000, 272.254700)
        },
        farm_spot = Vector(-1780.731689, -3910.019287, 274.012909);
        pull_path = {
          Vector(-2027.131836, -3579.098633, 272.058624),
          Vector(-2570.468750, -3342.687500, 261.396027),
        }
      },
      {
        boundary = {
          Vector(-1228.843750, -3609.156250, 288.613495),
          Vector(-1227.250000, -2950.031250, 283.818542),
          Vector(-15.508785, -2970.616211, 311.680908),
          Vector(-15.875000, -3626.281250, 333.992188)
        },
        farm_spot = Vector(-779.289673, -3299.927979, 280.345947);
        pull_path = {
          Vector(-1280.312500, -3295.500000, 271.027252),
          Vector(-1726.633179, -3738.784668, 274.608215)
        }
      },
      {
        boundary = {
          Vector(153.468750, -4096.812500, 369.068909),
          Vector(1138.000000, -4093.500000, 371.376892),
          Vector(1131.312500, -5109.843750, 379.409180),
          Vector(152.593750, -5111.250000, 384.392487)
        },
        farm_spot = Vector(677.943604, -4428.918945, 372.274414);
        pull_path = {
          Vector(655.768738, -4036.084473, 374.568726),
          Vector(948.672791, -3395.980957, 370.805634)
        }
      },
      {
        farm_spot = Vector(352.134644, -2118.402588, 290.645142),
        pull_path = {
          Vector(483.126068, -2557.718506, 288.971191),
          Vector(706.812500, -3129.250000, 340.123596)
        }
      },
      {
        farm_spot = Vector(3271.776611, -4609.055664, 316.431793),
        pull_path = {
          Vector(3587.218750, -4347.031250, 332.267792),
          Vector(3577.312500, -3850.312500, 323.240570),
          Vector(3687.499512, -3410.095459, 274.671753)
        }
      },
      {
        farm_spot = Vector(4441.295898, -4145.355469, 305.174438),
        pull_path = {
          Vector(3217.875000, -3647.531250, 292.047485)
        }
      }
    },

    radiant_secondary = {
      {
        farm_spot = Vector(-2730.058838, -216.015198, 305.473145),
        pull_path = {
          Vector(-2526.203125, -708.616211, 306.032623),
          Vector(-2952.606689, -1131.977539, 308.818420),
          Vector(-3349.312500, -1160.781250, 318.787903)
        }
      },
      {
        farm_spot = Vector(-4669.142578, -222.007629, 318.503418),
        pull_path = {
          Vector(-4800.203613, 159.815460, 314.177338),
          Vector(-4824.937500, 814.000000, 315.732941)
        }
      },
      {
        farm_spot = Vector(-3978.181396, 638.842957, 301.672363),
        pull_path = {
          Vector(-4479.437500, 424.718750, 299.293976),
          Vector(-4647.649902, 137.535767, 301.849792),
          Vector(-5097.440918, 224.635254, 305.543182)
        }
      }
    },

    dire_primary = {
      {
        farm_spot = Vector(-510.689697, 2337.769043, 320.546600),
        pull_path = {
          Vector(818.415222, 2369.375488, 327.092773)
        }
      },
      {
        farm_spot = Vector(1102.684082, 3468.536865, 352.204437),
        pull_path = {
          Vector(-85.917061, 4126.734375, 361.204742)
        }
      },
      {
        farm_spot = Vector(-406.406494, 3489.954590, 300.725433),
        pull_path = {
          Vector(-820.707520, 4117.163574, 321.617920),
          Vector(-1105.811035, 4426.592285, 322.930145)
        }
      },
      {
        farm_spot = Vector(-1694.763550, 3941.015381, 286.854156),
        pull_path = {
          Vector(-1483.109497, 3609.701904, 284.056519),
          Vector(-1132.337036, 3233.482910, 278.356201)
        }
      },
      {
        farm_spot = Vector(-3147.274902, 5018.506348, 364.825653),
        pull_path = {
          Vector(-3738.503662, 5213.838379, 368.214569),
          Vector(-4023.593750, 4739.718750, 364.649139)
        }
      },
      {
        farm_spot = Vector(-4289.701660, 3725.050049, 275.225677),
        pull_path = {
          Vector(-3556.840576, 3933.193604, 269.056946),
          Vector(-3075.687500, 3631.156250, 243.989456),
          Vector(-2865.741211, 3608.214111, 254.313599)
        }
      }
    },
    dire_secondary = {
      {
        farm_spot = Vector(2817.991211, 121.189766, 319.556580),
        pull_path = {
          Vector(4382.437500, 73.471069, 337.577148)
        }
      },
      {
        farm_spot = Vector(4162.419922, 794.806458, 350.197815),
        pull_path = {
          Vector(3358.218750, 421.718750, 338.555511)
        }
      },
      {
        farm_spot = Vector(3561.843018, -622.280334, 322.619843),
        pull_path = {
          Vector(2167.812500, -939.468750, 271.132660)
        }
      }
    }
  }
}

return map;
