#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CAMediaTimingFunction+MDCAnimationTiming.h"
#import "MaterialAnimationTiming.h"
#import "UIView+MDCTimingFunction.h"
#import "MaterialAvailability.h"
#import "MDCAvailability.h"
#import "MaterialButtons.h"
#import "MDCButton.h"
#import "MDCFlatButton.h"
#import "MDCFloatingButton+Animation.h"
#import "MDCFloatingButton.h"
#import "MDCRaisedButton.h"
#import "MaterialButtons+ColorThemer.h"
#import "MDCButtonColorThemer.h"
#import "MDCContainedButtonColorThemer.h"
#import "MDCFloatingButtonColorThemer.h"
#import "MDCOutlinedButtonColorThemer.h"
#import "MDCTextButtonColorThemer.h"
#import "MaterialButtons+ShapeThemer.h"
#import "MDCButtonShapeThemer.h"
#import "MaterialButtons+Theming.h"
#import "MDCButton+MaterialTheming.h"
#import "MDCFloatingButton+MaterialTheming.h"
#import "MaterialButtons+TypographyThemer.h"
#import "MDCButtonTypographyThemer.h"
#import "MaterialDialogs.h"
#import "MDCAlertController+ButtonForAction.h"
#import "MDCAlertController+Customize.h"
#import "MDCAlertController.h"
#import "MDCAlertControllerDelegate.h"
#import "MDCAlertControllerView.h"
#import "MDCDialogPresentationController.h"
#import "MDCDialogPresentationControllerDelegate.h"
#import "MDCDialogTransitionController.h"
#import "UIViewController+MaterialDialogs.h"
#import "MaterialElevation.h"
#import "MDCElevatable.h"
#import "MDCElevationOverriding.h"
#import "UIColor+MaterialElevation.h"
#import "UIView+MaterialElevationResponding.h"
#import "MaterialInk.h"
#import "MDCInkGestureRecognizer.h"
#import "MDCInkTouchController.h"
#import "MDCInkTouchControllerDelegate.h"
#import "MDCInkView.h"
#import "MDCInkViewDelegate.h"
#import "MaterialRipple.h"
#import "MDCRippleTouchController.h"
#import "MDCRippleTouchControllerDelegate.h"
#import "MDCRippleView.h"
#import "MDCRippleViewDelegate.h"
#import "MDCStatefulRippleView.h"
#import "MaterialShadowElevations.h"
#import "MDCShadowElevations.h"
#import "MaterialShadowLayer.h"
#import "MDCShadowLayer.h"
#import "MaterialShapeLibrary.h"
#import "MDCCornerTreatment+CornerTypeInitalizer.h"
#import "MDCCurvedCornerTreatment.h"
#import "MDCCurvedRectShapeGenerator.h"
#import "MDCCutCornerTreatment.h"
#import "MDCPillShapeGenerator.h"
#import "MDCRoundedCornerTreatment.h"
#import "MDCSlantedRectShapeGenerator.h"
#import "MDCTriangleEdgeTreatment.h"
#import "MaterialShapes.h"
#import "MDCCornerTreatment.h"
#import "MDCEdgeTreatment.h"
#import "MDCPathGenerator.h"
#import "MDCRectangleShapeGenerator.h"
#import "MDCShapedShadowLayer.h"
#import "MDCShapedView.h"
#import "MDCShapeGenerating.h"
#import "MaterialTabs+TabBarView.h"
#import "MDCTabBarItem.h"
#import "MDCTabBarItemCustomViewing.h"
#import "MDCTabBarView.h"
#import "MDCTabBarViewCustomViewable.h"
#import "MDCTabBarViewDelegate.h"
#import "MDCTabBarViewIndicatorAttributes.h"
#import "MDCTabBarViewIndicatorContext.h"
#import "MDCTabBarViewIndicatorTemplate.h"
#import "MDCTabBarViewUnderlineIndicatorTemplate.h"
#import "MaterialTextControls+BaseTextFields.h"
#import "MDCBaseTextField.h"
#import "MDCBaseTextFieldDelegate.h"
#import "MaterialTextControls+Enums.h"
#import "MDCTextControlLabelBehavior.h"
#import "MDCTextControlState.h"
#import "MaterialTextControls+FilledTextFields.h"
#import "MDCFilledTextField.h"
#import "MaterialTextControls+OutlinedTextFields.h"
#import "MDCOutlinedTextField.h"
#import "MaterialTypography.h"
#import "MDCFontScaler.h"
#import "MDCFontTextStyle.h"
#import "MDCTypography.h"
#import "UIFont+MaterialScalable.h"
#import "UIFont+MaterialSimpleEquality.h"
#import "UIFont+MaterialTypography.h"
#import "UIFontDescriptor+MaterialTypography.h"
#import "MaterialApplication.h"
#import "UIApplication+MDCAppExtensions.h"
#import "MaterialColor.h"
#import "UIColor+MaterialBlending.h"
#import "UIColor+MaterialDynamic.h"
#import "MaterialKeyboardWatcher.h"
#import "MDCKeyboardWatcher.h"
#import "MaterialMath.h"
#import "MDCMath.h"
#import "MaterialTextControlsPrivate+BaseStyle.h"
#import "MDCTextControlStyleBase.h"
#import "MDCTextControlVerticalPositioningReferenceBase.h"
#import "MaterialTextControlsPrivate+FilledStyle.h"
#import "MDCTextControlStyleFilled.h"
#import "MDCTextControlVerticalPositioningReferenceFilled.h"
#import "MaterialTextControlsPrivate+OutlinedStyle.h"
#import "MDCTextControlStyleOutlined.h"
#import "MDCTextControlVerticalPositioningReferenceOutlined.h"
#import "MaterialTextControlsPrivate+Shared.h"
#import "MDCTextControl.h"
#import "MDCTextControlAssistiveLabelDrawPriority.h"
#import "MDCTextControlAssistiveLabelView.h"
#import "MDCTextControlAssistiveLabelViewLayout.h"
#import "MDCTextControlColorViewModel.h"
#import "MDCTextControlGradientManager.h"
#import "MDCTextControlHorizontalPositioning.h"
#import "MDCTextControlHorizontalPositioningReference.h"
#import "MDCTextControlLabelAnimation.h"
#import "MDCTextControlLabelPosition.h"
#import "MDCTextControlPlaceholderSupport.h"
#import "MDCTextControlSideViewSupport.h"
#import "MDCTextControlVerticalPositioningReference.h"
#import "UIBezierPath+MDCTextControlStyle.h"
#import "MaterialTextControlsPrivate+TextFields.h"
#import "MDCBaseTextFieldLayout.h"
#import "MDCTextControlTextField.h"
#import "MDCTextControlTextFieldSideViewAlignment.h"
#import "MaterialTextControlsPrivate+UnderlinedStyle.h"
#import "MDCTextControlStyleUnderlined.h"
#import "MDCTextControlVerticalPositioningReferenceUnderlined.h"
#import "MaterialColorScheme.h"
#import "MDCLegacyColorScheme.h"
#import "MDCLegacyTonalColorScheme.h"
#import "MDCLegacyTonalPalette.h"
#import "MDCSemanticColorScheme.h"
#import "MaterialContainerScheme.h"
#import "MDCContainerScheme.h"
#import "MaterialShapeScheme.h"
#import "MDCShapeCategory.h"
#import "MDCShapeScheme.h"
#import "MaterialTypographyScheme.h"
#import "MDCLegacyFontScheme.h"
#import "MDCTypographyScheme.h"
#import "MaterialTypographyScheme+BasicFontScheme.h"
#import "MDCBasicFontScheme.h"
#import "MaterialTypographyScheme+Scheming.h"
#import "MDCTypographyScheming.h"

FOUNDATION_EXPORT double MaterialComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char MaterialComponentsVersionString[];
