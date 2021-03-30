#define S_FUNCTION_NAME  @SFunctionName
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include "abc.c"

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S)
{
    int_T             i;

    ssSetNumSFcnParams(S, 0);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    if (!ssSetNumInputPorts(S, @NumOfInports)) return;
	for (i=0; i<@NumOfInports; i++) {
	    ssSetInputPortWidth(S, i, DYNAMICALLY_SIZED);
	    ssSetInputPortDirectFeedThrough(S, i, 1);
	}

    if (!ssSetNumOutputPorts(S, @NumOfOutports)) return;
	for (i=0; i<@NumOfOutports; i++) {
	    ssSetOutputPortWidth(S, i, DYNAMICALLY_SIZED);
	}

    ssSetNumSampleTimes(S, 1);

    /* specify the sim state compliance to be same as a built-in block */
    ssSetOperatingPointCompliance(S, USE_DEFAULT_OPERATING_POINT);

    /* Set this S-function as runtime thread-safe for multicore execution */
    ssSetRuntimeThreadSafetyCompliance(S, RUNTIME_THREAD_SAFETY_COMPLIANCE_TRUE);
   
    ssSetOptions(S,
                 SS_OPTION_WORKS_WITH_CODE_REUSE |
                 SS_OPTION_EXCEPTION_FREE_CODE |
                 SS_OPTION_USE_TLC_WITH_ACCELERATOR);
}


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S); 
}

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    Call test target function.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    int_T             i, j;
	InputRealPtrsType uPtr;
    InputRealPtrsType uPtrs[@NumOfInports];
    real_T            *y;
    real_T            *ys[@NumOfOutports];
    int_T             width;
    int_T             widths[@NumOfOutports];

	for (i=0; i<@NumOfInports; i++) {
		uPtrs[i] = ssGetInputPortRealSignalPtrs(S, i);
	}

	for (i=0; i<@NumOfOutports; i++) {
		ys[i] = ssGetOutputPortRealSignal(S, i);
		widths[i] = ssGetOutputPortWidth(S, i);
	}

	/*
    g_a = (*uPtrs_a[i]);
    g_b = (*uPtrs_b[i]);
	*/
	@SetToInports

    @TargetFunctionName();

	for (i=0; i<@NumOfOutports; i++) {
		y = ys[i];
		width = widths[i];
	    for (j=0; j<width; j++) {
	    	/*
	        *y++ = g_c;
	    	*/
	    	@GetFromOutports
	    }
	}
}


/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S)
{
}



#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
