cmake_minimum_required(VERSION 2.8)

project("libvpx")

if(MSVC)
	set(CMAKE_C_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
	set(CMAKE_CXX_FLAGS "/EHsc /RTC1 /MTd /Zp16 /GS /Qpar /MP /wd4244")
endif(MSVC)

add_definitions(
)

include_directories(
	.
	../../src/libvpx
	../../src/libvpx/test
	../../src/libvpx/vp8
	../../src/libvpx/vp9
	../../src/libvpx/vp10
	../../src/libvpx/vpx_mem/include
	../../src/libvpx/vpx_mem/memory_manager/include
)

set(SRC_FILES
	../../src/libvpx/args.c
	../../src/libvpx/ivfdec.c
	../../src/libvpx/md5_utils.c
	../../src/libvpx/rate_hist.c
	../../src/libvpx/tools_common.c
	../../src/libvpx/video_reader.c
	../../src/libvpx/video_writer.c
	../../src/libvpx/vpxstats.c
	../../src/libvpx/warnings.c
	../../src/libvpx/y4menc.c
	../../src/libvpx/y4minput.c
	../../src/libvpx/webmdec.cc
#	../../src/libvpx/vp9/vp9_cx_iface.c
	../../src/libvpx/vp9/vp9_dx_iface.c
	../../src/libvpx/vp9/common/vp9_alloccommon.c
	../../src/libvpx/vp9/common/vp9_blockd.c
	../../src/libvpx/vp9/common/vp9_common_data.c
	../../src/libvpx/vp9/common/vp9_convolve.c
	../../src/libvpx/vp9/common/vp9_debugmodes.c
	../../src/libvpx/vp9/common/vp9_entropy.c
	../../src/libvpx/vp9/common/vp9_entropymode.c
	../../src/libvpx/vp9/common/vp9_entropymv.c
	../../src/libvpx/vp9/common/vp9_filter.c
	../../src/libvpx/vp9/common/vp9_frame_buffers.c
	../../src/libvpx/vp9/common/vp9_idct.c
	../../src/libvpx/vp9/common/vp9_loopfilter.c
	../../src/libvpx/vp9/common/vp9_mfqe.c
	../../src/libvpx/vp9/common/vp9_mvref_common.c
	../../src/libvpx/vp9/common/vp9_postproc.c
	../../src/libvpx/vp9/common/vp9_pred_common.c
	../../src/libvpx/vp9/common/vp9_prob.c
	../../src/libvpx/vp9/common/vp9_quant_common.c
	../../src/libvpx/vp9/common/vp9_reconinter.c
	../../src/libvpx/vp9/common/vp9_reconintra.c
	../../src/libvpx/vp9/common/vp9_rtcd.c
	../../src/libvpx/vp9/common/vp9_scale.c
	../../src/libvpx/vp9/common/vp9_scan.c
	../../src/libvpx/vp9/common/vp9_seg_common.c
	../../src/libvpx/vp9/common/vp9_textblit.c
	../../src/libvpx/vp9/common/vp9_thread.c
	../../src/libvpx/vp9/common/vp9_thread_common.c
	../../src/libvpx/vp9/common/vp9_tile_common.c
	../../src/libvpx/vp9/encoder/vp9_aq_complexity.c
	../../src/libvpx/vp9/encoder/vp9_aq_cyclicrefresh.c
	../../src/libvpx/vp9/encoder/vp9_aq_variance.c
	../../src/libvpx/vp9/encoder/vp9_avg.c
	../../src/libvpx/vp9/encoder/vp9_bitstream.c
	../../src/libvpx/vp9/encoder/vp9_context_tree.c
	../../src/libvpx/vp9/encoder/vp9_cost.c
	../../src/libvpx/vp9/encoder/vp9_dct.c
#	../../src/libvpx/vp9/encoder/vp9_denoiser.c
#	../../src/libvpx/vp9/encoder/vp9_encodeframe.c
#	../../src/libvpx/vp9/encoder/vp9_encodemb.c
#	../../src/libvpx/vp9/encoder/vp9_encodemv.c
#	../../src/libvpx/vp9/encoder/vp9_encoder.c
	../../src/libvpx/vp9/encoder/vp9_ethread.c
	../../src/libvpx/vp9/encoder/vp9_extend.c
#	../../src/libvpx/vp9/encoder/vp9_firstpass.c
	../../src/libvpx/vp9/encoder/vp9_lookahead.c
	../../src/libvpx/vp9/encoder/vp9_mbgraph.c
	../../src/libvpx/vp9/encoder/vp9_mcomp.c
	../../src/libvpx/vp9/encoder/vp9_picklpf.c
	../../src/libvpx/vp9/encoder/vp9_pickmode.c
	../../src/libvpx/vp9/encoder/vp9_quantize.c
	../../src/libvpx/vp9/encoder/vp9_ratectrl.c
	../../src/libvpx/vp9/encoder/vp9_rd.c
	../../src/libvpx/vp9/encoder/vp9_rdopt.c
	../../src/libvpx/vp9/encoder/vp9_resize.c
	../../src/libvpx/vp9/encoder/vp9_sad.c
	../../src/libvpx/vp9/encoder/vp9_segmentation.c
	../../src/libvpx/vp9/encoder/vp9_skin_detection.c
	../../src/libvpx/vp9/encoder/vp9_speed_features.c
	../../src/libvpx/vp9/encoder/vp9_ssim.c
	../../src/libvpx/vp9/encoder/vp9_subexp.c
	../../src/libvpx/vp9/encoder/vp9_svc_layercontext.c
	../../src/libvpx/vp9/encoder/vp9_temporal_filter.c
	../../src/libvpx/vp9/encoder/vp9_tokenize.c
	../../src/libvpx/vp9/encoder/vp9_treewriter.c
	../../src/libvpx/vp9/encoder/vp9_variance.c
	../../src/libvpx/vp9/encoder/vp9_write_bit_buffer.c
	../../src/libvpx/vp9/encoder/vp9_writer.c
	../../src/libvpx/vp9/decoder/vp9_decodeframe.c
	../../src/libvpx/vp9/decoder/vp9_decodemv.c
	../../src/libvpx/vp9/decoder/vp9_decoder.c
	../../src/libvpx/vp9/decoder/vp9_detokenize.c
	../../src/libvpx/vp9/decoder/vp9_dsubexp.c
	../../src/libvpx/vp9/decoder/vp9_dthread.c
	../../src/libvpx/vp9/decoder/vp9_read_bit_buffer.c
	../../src/libvpx/vp9/decoder/vp9_reader.c
	../../src/libvpx/vpx/src/vpx_codec.c
	../../src/libvpx/vpx/src/vpx_decoder.c
	../../src/libvpx/vpx/src/vpx_image.c
	../../src/libvpx/vpx/src/vpx_psnr.c
	../../src/libvpx/vpx_mem/vpx_mem.c
	../../src/libvpx/vpx_mem/vpx_mem_tracker.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_alloc.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_base.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_dflt_abort.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_grow.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_largest.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_resize.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_shrink.c
	../../src/libvpx/vpx_mem/memory_manager/hmm_true.c
	../../src/libvpx/vpx_scale/generic/gen_scalers.c
	../../src/libvpx/vpx_scale/generic/vpx_scale.c
	../../src/libvpx/vpx_scale/generic/yv12config.c
	../../src/libvpx/vpx_scale/generic/yv12extend.c
	../../src/libvpx/third_party/libwebm/mkvmuxer.cpp
	../../src/libvpx/third_party/libwebm/mkvmuxerutil.cpp
	../../src/libvpx/third_party/libwebm/mkvparser.cpp
	../../src/libvpx/third_party/libwebm/mkvreader.cpp
	../../src/libvpx/third_party/libwebm/mkvwriter.cpp
)

if(MSVC)
	set(SRC_FILES
		${SRC_FILES}
	)
else(MSVC)
	set(SRC_FILES
		${SRC_FILES}
	)
endif(MSVC)

add_library(libvpx ${SRC_FILES}
	)
