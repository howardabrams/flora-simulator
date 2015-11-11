# COMPUTER VARIABLES

memory = makeMemory()
pointer = 0
registerX = 0      # Easier with three registers?
registerY = 0      # Just ignore Y and Z for now...
registerZ = 0


# ----------------------------------------------------------------------
# COMPUTER FUNCTIONS
# ----------------------------------------------------------------------

stopProgram = () ->
     debug "End Program"

setMemory = (addr, value) ->
     memory[addr] = value
     debug "In setMemory"

loadRegisterX = (value) ->
     registerX = value
     debug "In loadRegisterX"

loadRegisterY = (value) ->
     registerY = value
     debug "In loadRegisterY"

loadAddressRegisterX = (addr) ->
     registerX = memory[addr]
     debug "In loadAddressRegisterX"

loadAddressRegisterY = (addr) ->
     registerY = memory[addr]
     debug "In loadAddressRegisterY"

storeRegisterX = (addr) ->
     memory[addr] = registerX
     debug "In storeRegisterX"

storeRegisterY = (addr) ->
     memory[addr] = registerY
     debug "In storeRegisterY"

addRegisters = () ->
     registerX = registerX + registerY
     debug "In addRegisters"

incrementRegisterX = () ->
     registerX++
     debug "In incrementRegisterX"

incrementRegisterY = () ->
     registerY++
     debug "In incrementRegisterY"

randomValue = () ->
        registerX = _.random(255)
        debug "in randomValue"

jumpAddress = (addr) ->
        pointer = addr
        debug "jumped"

# ----------------------------------------------------------------------
#  CODE LOOKUP TABLE
# ----------------------------------------------------------------------

operands = [{ abbr: "END", params: 0, code: stopProgram, help: "Ends the program"},
            { abbr: "SET", params: 2, code: setMemory,   help: "Sets memory address to value"},
            { abbr: "LDX", params: 1, code: loadRegisterX, help: "Loads a value into X Register"},
            { abbr: "LDY", params: 1, code: loadRegisterY, help: "Loads a value into Y Register"},
            { abbr: "LAX", params: 1, code: loadAddressRegisterX, help: "Loads value from address into X Register"},
            { abbr: "LAY", params: 1, code: loadAddressRegisterY, help: "Loads value from address into Y Register"},
            { abbr: "STX", params: 1, code: storeRegisterX, help: "Stores value in X Register to a memory address"},
            { abbr: "STY", params: 1, code: storeRegisterY, help: "Stores value in Y Register to a memory address"},
            { abbr: "ADD", params: 0, code: addRegisters, help: "Adds the values in X and Y Registers. Sum in X Register"},
            { abbr: "RND", params: 0, code: randomValue, help: "Puts a random value in X Register"},
            { abbr: "INX", params: 0, code: incrementRegisterX, help: "Increments X Register by 1"}
            { abbr: "INY", params: 0, code: incrementRegisterY, help: "Increments Y Register by 1"}
            { abbr: "JMP", params: 1, code: jumpAddress, help: "Jump to address"}
         ]

# ----------------------------------------------------------------------
# HELPER FUNCTIONS
# ----------------------------------------------------------------------

load = ->
     console.log "Loading..."

process = ->
     debug "Starting"
     step() while memory[pointer] != 0
     debug "Process Complete"

step = ->
     command = operands[ memory[pointer] ]
     switch command.params
             when 0
                pointer += 1
                command.code()
             when 1
                p1 = memory[pointer+1]
                pointer += 2
                command.code(p1)
             when 2
                p1 = memory[pointer+1]
                p2 = memory[pointer+2]
                pointer += 3
                command.code(p1, p2)

console.log "System Loaded."
