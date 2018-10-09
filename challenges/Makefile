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
	make -C challenge-aido1_luck/evaluation             define-challenge-no-cache
	make -C challenge-aido1_log_processing/evaluation   define-challenge-no-cache
	make -C challenge-aido1_dummy_sim/evaluation        define-challenge-no-cache
	make -C challenge-aido1_test_multistep/evaluation   define-challenge-no-cache
	make -C challenge-aido1_amod1        define-challenge-no-cache

define-challenge:
	make -C challenge-aido1_luck/evaluation             define-challenge
	make -C challenge-aido1_log_processing/evaluation   define-challenge
	make -C challenge-aido1_dummy_sim/evaluation        define-challenge
	make -C challenge-aido1_test_multistep/evaluation   define-challenge
	make -C challenge-aido1_amod1        define-challenge

submit:
	(cd challenge-aido1_luck/submission-random &&           dts challenges submit)
	(cd challenge-aido1_log_processing/submission &&        dts challenges submit)
	(cd challenge-aido1_dummy_sim/submission &&             dts challenges submit)
	(cd challenge-aido1_test_multistep/submission &&        dts challenges submit)
	(cd challenge-aido1_amod1-template-python &&  make submit)
	

