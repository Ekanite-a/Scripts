return setmetatable({
    [1] = {
        Name = "Obby",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                    "Replica",
                    "Cherry",
                },
                [2] = {
                    "Cherry",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                2,
                1,
            },
        },
    },
    [2] = {
        Name = "Cloud",
        help = true,
    },
    [3] = {
        Name = "Brick",
        help = true,
        HelperPosOffset = Vector3.new(2, -10, -4),
    },
    [4] = {
        Name = "Wormhole",
        SlapEvent = "WormHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                    "Replica",
                    "Cherry",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                1,
            },
        },
    },
    [5] = {
        Name = "Killstreak",
        SlapEvent = "KSHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [2] = {
                    "L.O.L.B.O.M.B",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                2,
            },
        },
    },
    [6] = {
        Name = "Ultra Instinct",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Default",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                1,
            },
        },
    },
    [7] = {
        Name = "Run",
        help = true,
        HelperPosOffset = Vector3.new(0, 5, -10),
        supported_gloves = {
            helper = {
                [2] = {
                    "L.O.L.B.O.M.B",
                },
            },
        },
        prior_task = {
            helper = {
                2,
            },
        },
    },
    [8] = {
        Name = "Glovel",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [2] = {
                    "Replica",
                    "Cherry",
                    "Pillow",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                2,
            },
        },
    },
    [9] = {
        Name = "bus",
        SlapEvent = "hitbus",
        help = true,
        HelperPosOffset = Vector3.new(10, 0, 0),
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                    "Cherry",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                1,
            },
        },
    },
    [10] = {
        Name = "[REDACTED]",
    },
    [11] = {
        Name = "🗿",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [3] = {
                    "Null",
                },
            },
        },
        prior_task = {
            -- recipient = {},
            helper = {
                3,
            },
        },
    },
    [12] = {
        Name = "Bomb",
    },
    [13] = {
        Name = "rob",
        help = true,
        HelperPosOffset = Vector3.new(0, 0, -5),
        supported_gloves = {
            recipient = {
                [1] = {
                    "Replica",
                },
            },
            helper = {
                [1] = {
                    "Cherry",
                },
            },
        },
        prior_task = {
            recipient = {
                1,
            },
            helper = {
                1,
            },
        },
    },
    [14] = {
        Name = "spin",
    },
    [15] = {
        Name = "Fort",
    },
    [16] = {
        Name = "Engineer",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Cherry"
                },
                [2] = {
                    "Cherry"
                },
            },
        },
        prior_task = {
            helper = {
                2,
                1,
            },
        },
    },
    [17] = {
        Name = "Flash",
        SlapEvent = "FlashHit",
        help = true,
    },
    [18] = {
        Name = "Booster",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Replica",
                    "Pillow",
                },
            },
        },
        prior_task = {
            helper = {
                1,
            },
        },
    },
    [19] = {
        Name = "Space",
        SlapEvent = "HtSpace",
        help = true,
    },
    [20] = {
        Name = "Shard",
        SlapEvent = "ShardHIT",
        help = true,
        HelperPosOffset = Vector3.new(0, 0, -160),
    },
    [21] = {
        Name = "Phase",
        SlapEvent = "PhaseH",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                    "Replica",
                    "Cherry",
                    "Pillow",
                },
            },
        },
        prior_task = {
            helper = {
                1,
            },
        },
    },
    [22] = {
        Name = "Tycoon",
        SlapEvent = "GeneralHit",
        help = true,
        --[[supported_gloves = {
            recipient = {},
            helper = {
            "Null",
            "Replica",
            "Cherry",
            "Pillow"
            }
        },
        prior_task = {
            helper = {
                
            },
        },]]
    },
    [23] = {
        Name = "Hive",
        SlapEvent = "GeneralHit",
        help = true,
    },
    [24] = {
        Name = "Defense",
        SlapEvent = "DefenseHit",
        help = true,
    },
    [25] = {
        Name = "Car Keys",
        help = true,
        HelperPosOffset = Vector3.new(0, 0, -25),
    },
    [26] = {
        Name = "Voodoo",
        SlapEvent = "GeneralHit",
        help = true,
    },
    [27] = {
        Name = "Cherry",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                },
            },
        },
        prior_task = {
            helper = {
                1,
            },
        },
    },
    [28] = {
        Name = "Stick",
        SlapEvent = "GeneralHit",
        help = true,
        supported_gloves = {
            -- recipient = {},
            helper = {
                [1] = {
                    "Null",
                },
            },
        },
        prior_task = {
            helper = {
                1,
            },
        },
    },
    [29] = {
        Name = "BONK",
        SlapEvent = "GeneralHit",
        help = true,
    },
    [30] = {
        Name = "Moon",
        SlapEvent = "CelestialHit",
        help = true,
    },
    Init = function(self)
        for i, v in ipairs(self) do
            if not v.HelperPosOffset then
                v.HelperPosOffset = Vector3.new(0, 0, -10)
            end
        end
    end,
    GetSupportedGloves = function(self, glove)
        local gloves = {
            helper = {},
            recipient = {},
        }
        if not self[glove].supported_gloves then
            return gloves
        end

        if self[glove].prior_task.recipient then
            for i, v in ipairs(self[glove].prior_task.recipient) do
                table.insert(
                    gloves.recipient,
                    self[glove].supported_gloves.recipient[v]
                )
            end
        end
        
        if self[glove].prior_task.helper then
            for i, v in ipairs(self[glove].prior_task.helper) do
                table.insert(
                    gloves.helper,
                    self[glove].supported_gloves.helper[v]
                )
            end
        end

        return gloves
    end,
}, {
    __index = function(t, val)
        for i, v in ipairs(t) do
            if v.Name == val then
                return v
            end
        end
    end
})