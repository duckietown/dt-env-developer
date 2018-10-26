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
	
	make -C testing/challenge-aido1_luck             define-challenge-no-cache
	make -C testing/challenge-aido1_log_processing   define-challenge-no-cache
	make -C testing/challenge-aido1_test_multistep   define-challenge-no-cache
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1      define-challenge-no-cache
	
	make -C aido1/tasks_amod/challenge-aido1_amod1        define-challenge-no-cache

define-challenge: 
	
	make -C testing/challenge-aido1_luck             define-challenge
	make -C testing/challenge-aido1_test_multistep   define-challenge
	make -C testing/challenge-aido1_log_processing   define-challenge
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1     define-challenge
	make -C aido1/tasks_amod/challenge-aido1_amod1       define-challenge


make-readme:

	dt-challenges-make-readme-definitions -C testing/challenge-aido1_luck
	dt-challenges-make-readme-definitions -C testing/challenge-aido1_test_multistep
	dt-challenges-make-readme-definitions -C testing/challenge-aido1_log_processing
	dt-challenges-make-readme-definitions -C aido1/tasks_embodied/challenge-aido1_LF1
	dt-challenges-make-readme-definitions -C aido1/tasks_amod/challenge-aido1_amod1

make-readme-templates:

	dt-challenges-make-readme-templates -C aido1/tasks_embodied/challenge-aido1_LF1-template-tensorflow
	dt-challenges-make-readme-templates -C aido1/tasks_embodied/challenge-aido1_LF1-template-random

	dt-challenges-make-readme-templates -C aido1/tasks_amod/challenge-aido1_amod1-template-python
	dt-challenges-make-readme-templates -C aido1/tasks_amod/challenge-aido1_amod1-template-java


submit: 
	
	dts challenges submit -C testing/challenge-aido1_luck-template-python

	dts challenges submit -C testing/challenge-aido1_log_processing/submission
	dts challenges submit -C testing/challenge-aido1_test_multistep/submission
	
	make -C aido1/tasks_embodied/challenge-aido1_LF1-template-pytorch submit
	make -C aido1/tasks_embodied/challenge-aido1_LF1-template-random submit
	make -C aido1/tasks_embodied/challenge-aido1_LF1-template-ros submit
	make -C aido1/tasks_embodied/challenge-aido1_LF1-template-tensorflow submit
	make -C challenge-aido1_LF1-baseline-IL-logs-tensorflow
	make -C challenge-aido1_LF1-baseline-IL-sim-tensorflow
	make -C challenge-aido1_LF1-baseline-RL-sim-pytorch
	make -C challenge-aido1_LF1-baseline-duckietown

	make -C aido1/tasks_amod/challenge-aido1_amod1-template-python submit
	make -C aido1/tasks_amod/challenge-aido1_amod1-template-java submit
	


