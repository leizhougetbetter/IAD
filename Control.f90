!-----------------2016-5-20-------------------------------!
! Heterogeneous Aspiration Dynamics - Coauther with BinWu !
!---------------------------------------------------------!
module global
    !!! use the Random Number Generators from the IMSL library
    use MT_PNRG
    !!!
    implicit none
    !!! Population size
    integer,parameter::Ntotal = 100
    !!! Group size
    integer,save::numPlayerInGame
    !!!
    real,save::selectionIntensity
    real,save::a0Beg, a0End, a0Gap
    !!!
    !!! Strategy: A Player -- 1; B Player -- 0
    integer,save::strategyPGG(Ntotal)
    !!! Aspiration values
    real,save::aspirationValueNode(Ntotal)
    !!! Initial frequency of A player
    real,save::initialFrequencyA = 0.8
    !!!!
    integer,parameter::minimumDegree = 2
    !!! Degree of each node on a network
    integer,save::degreeMain(Ntotal)
    !!!
    character(4),save::networkType
    !!! Neighbors of each node
    type structuredPopulations
        integer,allocatable::neighborNode(:)
    end type
    !!!
    !
end module
    
INCLUDE 'link_fnl_static.h'
!DEC$ OBJCOMMENT LIB:'libiomp5md.lib'
program main
    use global
    implicit none
    integer::numGraphRealization
    integer::timesRepeated
    !!!
    character(32)::inputFileName
    character(19)::inputFileNameValueY
    logical::alive
    !!!
    real,allocatable::APlayerPayoff(:), BPlayerPayoff(:)
    namelist /keyParameters/ networkType, a0Beg, a0End, a0Gap, timesRepeated, initialFrequencyA
    !!!
    numGraphRealization = 1
    !!!
    timesRepeated = 40
    
    !!!
    aspirationValueNode = -1.0
    !!! ------ Input delta of y values and interval of y ------ !!!
    inputFileNameValueY = 'OtherParameters.inp'
    inquire(file = inputFileNameValueY, exist = alive)
    if(.not. alive)then
        write(*,*) "ERROR: File "//inputFileNameValueY//" is NOT found!"
        stop
    end if
    open(unit = 166, file = inputFileNameValueY,status = 'old')
    read(166, nml = keyParameters) 
    close(166)       
    !!! ----- Read Parameters Line By Line ----- !!!
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
    write(*,"(2X,'Initial freqneucy of A = ', F5.2)") initialFrequencyA
    write(*,*) "----------------"
    
    if(any(aspirationValueNode == -1.0))then
        write(*,*) "The number of Aspiration Values MUST equal to the population size!"
        stop
    elseif(selectionIntensity < 0)then
        write(*,*) "The Selection Intensity MUST be Non-nagetive!"
        stop
    end if
    !stop
    
    !!! RNOPT(8) --- A 32-bit Mersenne Twister generator is used.
    call RNOPT(8)  
    !!! Main program calculating the average abundance of strategies
    call frequencyCalculation(timesRepeated, numGraphRealization, &
    APlayerPayoff, BPlayerPayoff)
    !stop
end
    