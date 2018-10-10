all:

	@echo 'To work locally set DTSERVER:'
	@echo 
	@echo '    $$ export DTSERVER=http://localhost:6544'
	@echo '    $$ make define-challenge'
	@echo '    $$ make submit'
	@echo
	@echo For remote, make sure DTSERVER is not set:
	@echo  
	@echo   
	@echo '    $$ env -u DTSERVER make define-challenge'
	@echo '    $$ env -u DTSERVER make submit'
	@echo
	@echo ''



define-challenge-no-cache:
	echo $(DTSERVER)
	-grep -r v3-devel . 
	
	make -C testing/challenge-aido1_luck             define-challenge-no-cache
	make -C testing/challenge-aido1_log_processing   define-challenge-no-cache
	make -C testing/challenge-aido1_test_multistep   define-challenge-no-cache
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1      define-challenge-no-cache
	
	make -C aido1/tasks_amod/challenge-aido1_amod1        define-challenge-no-cache

define-challenge:
	echo $(DTSERVER)
	-grep -r v3-devel . 
	
	make -C testing/challenge-aido1_luck             define-challenge
	make -C testing/challenge-aido1_test_multistep   define-challenge
	make -C testing/challenge-aido1_log_processing   define-challenge
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1     define-challenge
	make -C aido1/tasks_amod/challenge-aido1_amod1       define-challenge

submit:
	echo $(DTSERVER)
	-grep -r v3-devel . 
	
	dts challenges submit -C testing/challenge-aido1_luck/submission-random
	dts challenges submit -C testing/challenge-aido1_log_processing/submission
	dts challenges submit -C testing/challenge-aido1_test_multistep/submission
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1-template-tensorflow submit
	make -C aido1/tasks_amod/challenge-aido1_amod1-template-python submit
	


