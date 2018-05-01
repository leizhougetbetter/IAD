!-----------------2018-4-30-------------------------------!
! Individualized Aspiration Dynamics 
! For Figure 1 & 2
!---------------------------------------------------------!
module global
    use MT_PNRG
    implicit none
    !
    integer,parameter::Ntotal = 100
    !
    integer,save::numPlayerInGame
    !!! 
    !!! ---- On Ring Graphs ----
    !!! payoffCollectType: 1---Average Payoff, 0---Singel game payoff
    integer,save:: payoffCollectType = 1
    !!! ----------------------------------
    real, save:: initialFrequencyA = 0.05
    !
    real,save::selectionIntensity
    !!!
    !!!
    !!! strategyPGG: A Player -- 1; B Player -- 0
    integer,save::strategyPGG(Ntotal)
    !!!
    real,save::aspirationValueNode(Ntotal)
    !!!!
    integer,save::degreeMain = 2
    !!!
    type structuredPopulations
        integer,allocatable::neighborNode(:)
    end type
    !
end module
    
INCLUDE 'link_fnl_static.h'
!DEC$ OBJCOMMENT LIB:'libiomp5md.lib'
program main
    use global
    implicit none
    integer::generationNum
    integer::timesRepeated
    !Number of nodes  
    character(32)::inputFileName
    !Number of nodes  
    character(15)::inputFileNameValueY
    logical::alive
    !!!
    real,allocatable::APlayerPayoff(:), BPlayerPayoff(:)
    namelist /keyParameters/ payoffCollectType, timesRepeated, generationNum, initialFrequencyA

    !!! ------ One parameter File ------ !!!
    inputFileNameValueY = 'yParameters.inp'
    inquire(file = inputFileNameValueY, exist = alive)
    if(.not. alive)then
        write(*,*) "ERROR: File "//inputFileNameValueY//" is NOT found!"
        stop
    end if
    open(unit = 166, file = inputFileNameValueY,status = 'old')
    read(166, nml = keyParameters) 
    close(166) 

    aspirationValueNode = -1.0
    !!! ----- Main Parameter File, Read By Line ----- !!!
    inputFileName = 'AspirationDynamicsParameters.txt'
    !
    inquire(file = inputFileName, exist = alive)
    if(.not. alive)then
        write(*,*) "ERROR: File "//inputFileName//" is NOT found!"
        stop
    end if
    open(unit = 188, file = inputFileName,status = 'old')
    !!!
    read(188,*)
    read(188,*)
    read(188,*)
    read(188,*)
    !!!
    read(188,*) 
    read(188,*) numPlayerInGame 
    !!!
    allocate(APlayerPayoff(numPlayerInGame))
    allocate(BPlayerPayoff(numPlayerInGame))
    !!!
    read(188,*) 
    read(188,*) 
    read(188,*) APlayerPayoff
    read(188,*) BPlayerPayoff
    !!!
    read(188,*) 
    read(188,*) aspirationValueNode
    !!!!
    read(188,*) 
    read(188,*) selectionIntensity
    !!!
    write(*,*) 
    write(*,"(' Population Size = ', I3)") Ntotal
    write(*,*) "----------------"
    write(*,"(' # of Player in a game = ', I3)") numPlayerInGame
    write(*,*) "----------------"
    write(*,"('  Payoff Parameters')")
    write(*,*) "A:",APlayerPayoff
    write(*,*) "B:",BPlayerPayoff
    write(*,*) "----------------"
    write(*,*) "value:"
    write(*,*) aspirationValueNode
    write(*,*) "----------------"
    write(*,"(' Selection Intensity = ', F8.5)") selectionIntensity
    write(*,*) "----------------"
    write(*,"(2X,'RepeatedTimes = ', I5)") timesRepeated
    write(*,*) "----------------"
    write(*,"(2X,'Payoff Collection = ', I1, ' (On graphs)')") payoffCollectType
    write(*,*) "----------------"    
    write(*,"(2X,'GenerationNum_OneLoop = ', I8)") GenerationNum
    write(*,*) "----------------"    

    if(any(aspirationValueNode == -1.0))then
        write(*,*) "The number of Aspiration Values MUST equal to the population size!"
        stop
    elseif(selectionIntensity < 0)then
        write(*,*) "The Selection Intensity MUST be Non-nagetive!"
        stop
    end if
    
    !!!! RNOPT(8) --- A 32-bit Mersenne Twister generator is used.
    !!! RNOPT(9) --- A 64-bit Mersenne Twister generator is used.
    call RNOPT(8)      
    
    call frequencyCalculation2(timesRepeated, generationNum, &
    APlayerPayoff, BPlayerPayoff)    
    !stop
end
    