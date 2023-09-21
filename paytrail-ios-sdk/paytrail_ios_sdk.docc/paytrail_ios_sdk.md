# ``paytrail_ios_sdk``

Paytrail_ios_sdk is a framework created to incapsulate the Paytrail web APIs for the iOS mobile development so that developers can easily integrate the Paytrail payment solutions without the need of creating the incapsulation of their own.

## What does the framework contain? 
**Payment APIs:**
- *Create payment* => ``createPayment(of:secret:payload:completion:)``: create a normal payment transcation
- *Get payment* => ``getPayment(of:secret:transactionId:completion:)``: retrieve an exisiting payment
- *Get grouped payment providers* => ``getGroupedPaymentProviders(of:secret:amount:groups:language:completion:)``: retrieve a set of grouped payment providers without the need of creating a payment in the first place

**Token Payment APIs:**
- *Get token* => ``getToken(of:merchantId:secret:completion:)``: retrieve the token of a payment card to be saved and used in token payment
- *Create token payment* => ``createTokenPayment(of:secret:payload:transactionType:authorizationType:completion:)``: create a token payment transaction by the retrieved card token
- *Commit a token authorization hold* => ``commitAuthorizationHold(of:secret:transactionId:payload:completion:)``: commit a onhold token authorization
- *Revert an token authorization hold* => ``revertAuthorizationHold(of:secret:transactionId:completion:)``: revert an onhold token authorization
- *Pay and add card =>* ``payAndAddCard(of:secret:payload:completion:)``: create a transaction and pay while adding the payment card at the same time

**Payment Views and Components**
- ``PaymentProvidersView``: a SwiftUI view component for showing the available ``PaymentMethodProvider`` by its representative icon, grouped by ``PaymentMethodGroup``. The view shows each provider in a grid which can be inserted into any SwiftUI view as a component. For the alternative counterpart for 'UIViewController', see ``loadPaymentProvidersUIView(with:groups:delegate:)``
- ``PaymentWebView``: a SwiftUI view for showing and taking care of a payment web view with the request and responses. For the alternative counterpart for 'UIViewController', see ``loadPaymentUIWebView(from:merchant:delegate:)``
- ``PaytrailThemes``: it takes care of the theming of ``PaymentWebView``, providing the basic themes of the view's fore- and background color customization, group header font size, and provider icon size.

## Topics

### Create Normal Payment

**Required APIs and Views:**
``createPayment(of:secret:payload:completion:)`` | ``initiatePaymentRequest(from:)`` | ``renderPaymentProviderImage(by:completion:)`` | ``PaymentProvidersView`` | ``loadPaymentProvidersUIView(with:groups:delegate:)`` | ``PaymentWebView`` | ``loadPaymentUIWebView(from:merchant:delegate:)``

**Required Data Models**
``PaymentRequestBody`` | ``PaymentRequestResponse`` | ``PaymentMethodProvider`` | ``PaymentResult``

**Flow Chart:**
![CreatePayment](Create_payment_api_flow.jpg)


- ``Symbol``
- What is the normal payment flow? 
- What APIs are called?
- Provide sample code

### Card Tokenization and Payment
- ``Symbol``
- What is the card tokenization flow? 
- and token payment flow?
- What APIs are called
- Provide sample code

### Add Card and Pay
- ``Symbol``
- What is add card and pay flow?
- What APIs are called?
- Provide sample code

### Miscellaneous

Toggle Logging
- ``Symbol``
- How enable Logging for debug

#### HMAC Signature
- How to get and varify HMAC Signature

#### Usage of MSDK Views in an UIViewController
- How to use the MSDK views in a VC
- Create your own Views for the MSDK
- Provide sample code

#### Known Issues
- Explain the current PaymentWebView issue if it is stil valid
- Others


## Reference
Refer to Paytrail's web API docs and other necessary ones
