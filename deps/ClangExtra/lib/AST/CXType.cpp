#include "clang-ex/AST/CXType.h"
#include "utils.h"
#include "clang/AST/Decl.h"
#include "clang/AST/TemplateBase.h"
#include "clang/AST/Type.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/PrettyPrinter.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/CanonicalType.h"

// Drift alarm: the vendored TypeNodes.inc must match the pinned LLVM version.
// One assert per concrete class proves CXTypeClass equals clang's TypeClass
// value-for-value; the TypeLast assert catches classes appended at the end.
#define TYPE(Class, Base)                                                                  \
  static_assert(static_cast<int>(CXTypeClass_##Class) ==                                   \
                    static_cast<int>(clang::Type::Class),                                   \
                "CXTypeClass drift: " #Class);
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"
static_assert(static_cast<int>(CXTypeClass_TypeLast) ==
                  static_cast<int>(clang::Type::TypeLast),
              "CXTypeClass drift: vendored TypeNodes.inc is missing classes");

#define TYPE(Class, Base)                                                                  \
  CX##Class##Type clang_Type_castTo##Class##Type(CXType_ T) {                               \
    return reinterpret_cast<CX##Class##Type>(                                               \
        llvm::dyn_cast_or_null<clang::Class##Type>(                                         \
            reinterpret_cast<clang::Type *>(T)));                                           \
  }
#include "clang-ex/AST/TypeNodes.inc"

CXTypeClass clang_Type_getTypeClass(CXType_ T) {
  return static_cast<CXTypeClass>(reinterpret_cast<clang::Type *>(T)->getTypeClass());
}

// Qualifiers
unsigned clang_Qualifiers_removeCommonQualifiers(unsigned *L, unsigned *R) {
  clang::Qualifiers LQ = clang::Qualifiers::fromOpaqueValue(*L);
  clang::Qualifiers RQ = clang::Qualifiers::fromOpaqueValue(*R);
  clang::Qualifiers Common = clang::Qualifiers::removeCommonQualifiers(LQ, RQ);
  *L = LQ.getAsOpaqueValue();
  *R = RQ.getAsOpaqueValue();
  return Common.getAsOpaqueValue();
}
unsigned clang_Qualifiers_fromFastMask(unsigned Mask) {
  return clang::Qualifiers::fromFastMask(Mask).getAsOpaqueValue();
}
unsigned clang_Qualifiers_fromCVRMask(unsigned CVR) {
  return clang::Qualifiers::fromCVRMask(CVR).getAsOpaqueValue();
}
unsigned clang_Qualifiers_fromCVRUMask(unsigned CVRU) {
  return clang::Qualifiers::fromCVRUMask(CVRU).getAsOpaqueValue();
}

bool clang_Qualifiers_hasConst(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasConst();
}

bool clang_Qualifiers_hasOnlyConst(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasOnlyConst();
}

unsigned clang_Qualifiers_withConst(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).withConst().getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeConst(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeConst();
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasVolatile(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasVolatile();
}

bool clang_Qualifiers_hasOnlyVolatile(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasOnlyVolatile();
}

unsigned clang_Qualifiers_withVolatile(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).withVolatile().getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeVolatile(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeVolatile();
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasRestrict(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasRestrict();
}

bool clang_Qualifiers_hasOnlyRestrict(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasOnlyRestrict();
}

unsigned clang_Qualifiers_withRestrict(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).withRestrict().getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeRestrict(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeRestrict();
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasCVRQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasCVRQualifiers();
}

unsigned clang_Qualifiers_getCVRQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).getCVRQualifiers();
}

unsigned clang_Qualifiers_getCVRUQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).getCVRUQualifiers();
}

unsigned clang_Qualifiers_setCVRQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setCVRQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addCVRQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addCVRQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeCVRQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeCVRQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addCVRUQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addCVRUQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasUnaligned(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasUnaligned();
}

unsigned clang_Qualifiers_setUnaligned(unsigned Quals, bool Flag) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setUnaligned(Flag);
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasObjCGCAttr(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasObjCGCAttr();
}

CXQualifiers_GC clang_Qualifiers_getObjCGCAttr(unsigned Quals) {
  return static_cast<CXQualifiers_GC>(
      clang::Qualifiers::fromOpaqueValue(Quals).getObjCGCAttr());
}

unsigned clang_Qualifiers_setObjCGCAttr(unsigned Quals, CXQualifiers_GC Attr) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setObjCGCAttr(static_cast<clang::Qualifiers::GC>(Attr));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addObjCGCAttr(unsigned Quals, CXQualifiers_GC Attr) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addObjCGCAttr(static_cast<clang::Qualifiers::GC>(Attr));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_withoutObjCGCAttr(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  return Qs.withoutObjCGCAttr().getAsOpaqueValue();
}

unsigned clang_Qualifiers_withoutObjCLifetime(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  return Qs.withoutObjCLifetime().getAsOpaqueValue();
}

bool clang_Qualifiers_hasObjCLifetime(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasObjCLifetime();
}

CXQualifiers_ObjCLifetime clang_Qualifiers_getObjCLifetime(unsigned Quals) {
  return static_cast<CXQualifiers_ObjCLifetime>(
      clang::Qualifiers::fromOpaqueValue(Quals).getObjCLifetime());
}

unsigned clang_Qualifiers_setObjCLifetime(unsigned Quals,
                                          CXQualifiers_ObjCLifetime Lifetime) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setObjCLifetime(static_cast<clang::Qualifiers::ObjCLifetime>(Lifetime));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addObjCLifetime(unsigned Quals,
                                          CXQualifiers_ObjCLifetime Lifetime) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addObjCLifetime(static_cast<clang::Qualifiers::ObjCLifetime>(Lifetime));
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasNonTrivialObjCLifetime(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasNonTrivialObjCLifetime();
}

bool clang_Qualifiers_hasStrongOrWeakObjCLifetime(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasStrongOrWeakObjCLifetime();
}

bool clang_Qualifiers_compatiblyIncludesObjCLifetime(unsigned Quals, unsigned Other) {
  return clang::Qualifiers::fromOpaqueValue(Quals).compatiblyIncludesObjCLifetime(
      clang::Qualifiers::fromOpaqueValue(Other));
}

unsigned clang_Qualifiers_withoutAddressSpace(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  return Qs.withoutAddressSpace().getAsOpaqueValue();
}

bool clang_Qualifiers_hasAddressSpace(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasAddressSpace();
}

CXLangAS clang_Qualifiers_getAddressSpace(unsigned Quals) {
  return static_cast<CXLangAS>(clang::Qualifiers::fromOpaqueValue(Quals).getAddressSpace());
}

bool clang_Qualifiers_hasTargetSpecificAddressSpace(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasTargetSpecificAddressSpace();
}

unsigned clang_Qualifiers_getAddressSpaceAttributePrintValue(unsigned Quals) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  return Qs.getAddressSpaceAttributePrintValue();
}

unsigned clang_Qualifiers_setAddressSpace(unsigned Quals, CXLangAS Space) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setAddressSpace(static_cast<clang::LangAS>(Space));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addAddressSpace(unsigned Quals, CXLangAS Space) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addAddressSpace(static_cast<clang::LangAS>(Space));
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasFastQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasFastQualifiers();
}

unsigned clang_Qualifiers_getFastQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).getFastQualifiers();
}

unsigned clang_Qualifiers_setFastQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.setFastQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addFastQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addFastQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeFastQualifiers(unsigned Quals, unsigned Mask) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeFastQualifiers(Mask);
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_hasNonFastQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasNonFastQualifiers();
}

unsigned clang_Qualifiers_getNonFastQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals)
      .getNonFastQualifiers()
      .getAsOpaqueValue();
}

bool clang_Qualifiers_hasQualifiers(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).hasQualifiers();
}

bool clang_Qualifiers_empty(unsigned Quals) {
  return clang::Qualifiers::fromOpaqueValue(Quals).empty();
}

unsigned clang_Qualifiers_addQualifiers(unsigned Quals, unsigned Other) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addQualifiers(clang::Qualifiers::fromOpaqueValue(Other));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_removeQualifiers(unsigned Quals, unsigned Other) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.removeQualifiers(clang::Qualifiers::fromOpaqueValue(Other));
  return Qs.getAsOpaqueValue();
}

unsigned clang_Qualifiers_addConsistentQualifiers(unsigned Quals, unsigned Other) {
  clang::Qualifiers Qs = clang::Qualifiers::fromOpaqueValue(Quals);
  Qs.addConsistentQualifiers(clang::Qualifiers::fromOpaqueValue(Other));
  return Qs.getAsOpaqueValue();
}

bool clang_Qualifiers_isAddressSpaceSupersetOf(CXLangAS A, CXLangAS B) {
  clang::LangAS AS_A = static_cast<clang::LangAS>(A);
  clang::LangAS AS_B = static_cast<clang::LangAS>(B);
  return clang::Qualifiers::isAddressSpaceSupersetOf(AS_A, AS_B);
}

bool clang_Qualifiers_compatiblyIncludes(unsigned Quals, unsigned Other) {
  return clang::Qualifiers::fromOpaqueValue(Quals).compatiblyIncludes(
      clang::Qualifiers::fromOpaqueValue(Other));
}

bool clang_Qualifiers_isStrictSupersetOf(unsigned Quals, unsigned Other) {
  return clang::Qualifiers::fromOpaqueValue(Quals).isStrictSupersetOf(
      clang::Qualifiers::fromOpaqueValue(Other));
}

CXString clang_Qualifiers_getAsString(unsigned Quals) {
  return extra::makeCXString(clang::Qualifiers::fromOpaqueValue(Quals).getAsString());
}

CXString clang_Qualifiers_getAddrSpaceAsString(CXLangAS AS) {
  std::string S = clang::Qualifiers::getAddrSpaceAsString(static_cast<clang::LangAS>(AS));
  return extra::makeCXString(S);
}

bool clang_Qualifiers_isEmptyWhenPrinted(unsigned Quals, CXASTContext Ctx) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  return clang::Qualifiers::fromOpaqueValue(Quals).isEmptyWhenPrinted(
      C->getPrintingPolicy());
}

CXString clang_Qualifiers_printAsString(unsigned Quals, CXASTContext Ctx,
                                        bool AppendSpaceIfNonEmpty) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::Qualifiers::fromOpaqueValue(Quals).print(OS, C->getPrintingPolicy(),
                                                  AppendSpaceIfNonEmpty);
  return extra::makeCXString(Str);
}

// SplitQualType
void clang_SplitQualType_getSingleStepDesugaredType(CXType_ Ty, unsigned Quals,
                                                    CXType_ *OutTy, unsigned *OutQuals) {
  clang::SplitQualType Split(reinterpret_cast<clang::Type *>(Ty),
                             clang::Qualifiers::fromOpaqueValue(Quals));
  clang::SplitQualType Desugared = Split.getSingleStepDesugaredType();
  *OutTy = reinterpret_cast<CXType_>(const_cast<clang::Type *>(Desugared.Ty));
  *OutQuals = Desugared.Quals.getAsOpaqueValue();
}

// QualType
CXQualType clang_QualType_constructFromTypePtr(CXType_ Ptr, unsigned Quals) {
  return reinterpret_cast<CXQualType>(clang::QualType(reinterpret_cast<clang::Type *>(Ptr), Quals).getAsOpaquePtr());
}

CXType_ clang_QualType_getTypePtr(CXQualType OpaquePtr) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getTypePtr()));
}

CXType_ clang_QualType_getTypePtrOrNull(CXQualType OpaquePtr) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getTypePtrOrNull()));
}

void clang_QualType_split(CXQualType OpaquePtr, CXType_ *Ty, unsigned *Quals) {
  clang::SplitQualType Split = clang::QualType::getFromOpaquePtr(OpaquePtr).split();
  *Ty = reinterpret_cast<CXType_>(const_cast<clang::Type *>(Split.Ty));
  *Quals = Split.Quals.getAsOpaqueValue();
}

void clang_QualType_getSplitUnqualifiedType(CXQualType OpaquePtr, CXType_ *Ty,
                                            unsigned *Quals) {
  clang::SplitQualType Split =
      clang::QualType::getFromOpaquePtr(OpaquePtr).getSplitUnqualifiedType();
  *Ty = reinterpret_cast<CXType_>(const_cast<clang::Type *>(Split.Ty));
  *Quals = Split.Quals.getAsOpaqueValue();
}

void clang_QualType_getSplitDesugaredType(CXQualType OpaquePtr, CXType_ *Ty,
                                          unsigned *Quals) {
  clang::SplitQualType Split =
      clang::QualType::getFromOpaquePtr(OpaquePtr).getSplitDesugaredType();
  *Ty = reinterpret_cast<CXType_>(const_cast<clang::Type *>(Split.Ty));
  *Quals = Split.Quals.getAsOpaqueValue();
}

bool clang_QualType_isCanonical(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCanonical();
}

bool clang_QualType_isCanonicalAsParam(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCanonicalAsParam();
}

bool clang_QualType_isNull(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isNull();
}

bool clang_QualType_isConstQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isConstQualified();
}

bool clang_QualType_isRestrictQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isRestrictQualified();
}

bool clang_QualType_isVolatileQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isVolatileQualified();
}

bool clang_QualType_hasQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasQualifiers();
}

CXQualType clang_QualType_withConst(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).withConst().getAsOpaquePtr());
}

CXQualType clang_QualType_withVolatile(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).withVolatile().getAsOpaquePtr());
}

CXQualType clang_QualType_withRestrict(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).withRestrict().getAsOpaquePtr());
}

CXQualType clang_QualType_withCVRQualifiers(CXQualType OpaquePtr, unsigned CVR) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .withCVRQualifiers(CVR)
      .getAsOpaquePtr());
}

CXQualType clang_QualType_addConst(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addConst();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_QualType_addVolatile(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addVolatile();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_QualType_addRestrict(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.addRestrict();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

bool clang_QualType_isLocalConstQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalConstQualified();
}

bool clang_QualType_isLocalRestrictQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalRestrictQualified();
}

bool clang_QualType_isLocalVolatileQualified(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isLocalVolatileQualified();
}

bool clang_QualType_hasLocalQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasLocalQualifiers();
}

bool clang_QualType_hasLocalNonFastQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasLocalNonFastQualifiers();
}

unsigned clang_QualType_getLocalCVRQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getLocalCVRQualifiers();
}

unsigned clang_QualType_getCVRQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getCVRQualifiers();
}

unsigned clang_QualType_getQualifiersAsOpaqueValue(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getQualifiers().getAsOpaqueValue();
}

unsigned clang_QualType_getLocalFastQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).getLocalFastQualifiers();
}

// QualType::UseExcessPrecision is non-const, so it runs on a local copy of the decoded
// value type rather than on a temporary.
bool clang_QualType_UseExcessPrecision(CXQualType OpaquePtr, CXASTContext Ctx) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  return T.UseExcessPrecision(*reinterpret_cast<clang::ASTContext *>(Ctx));
}

CXQualType clang_QualType_removeLocalConst(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.removeLocalConst();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_QualType_removeLocalVolatile(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.removeLocalVolatile();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_QualType_removeLocalRestrict(CXQualType OpaquePtr) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  T.removeLocalRestrict();
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_QualType_withFastQualifiers(CXQualType OpaquePtr, unsigned TQs) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .withFastQualifiers(TQs)
      .getAsOpaquePtr());
}

CXQualType clang_QualType_withExactLocalFastQualifiers(CXQualType OpaquePtr, unsigned TQs) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .withExactLocalFastQualifiers(TQs)
      .getAsOpaquePtr());
}

CXQualType clang_QualType_withoutLocalFastQualifiers(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .withoutLocalFastQualifiers()
      .getAsOpaquePtr());
}

bool clang_QualType_hasAddressSpace(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasAddressSpace();
}

CXLangAS clang_QualType_getAddressSpace(CXQualType OpaquePtr) {
  return static_cast<CXLangAS>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getAddressSpace());
}

CXDestructionKind clang_QualType_isDestructedType(CXQualType OpaquePtr) {
  return static_cast<CXDestructionKind>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).isDestructedType());
}

bool clang_QualType_isMoreQualifiedThan(CXQualType OpaquePtr, CXQualType Other) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isMoreQualifiedThan(
      clang::QualType::getFromOpaquePtr(Other));
}

bool clang_QualType_isAddressSpaceOverlapping(CXQualType OpaquePtr, CXQualType Other) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isAddressSpaceOverlapping(
      clang::QualType::getFromOpaquePtr(Other));
}

CXQualifiers_GC clang_QualType_getObjCGCAttr(CXQualType OpaquePtr) {
  return static_cast<CXQualifiers_GC>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getObjCGCAttr());
}

bool clang_QualType_isObjCGCWeak(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isObjCGCWeak();
}

bool clang_QualType_isObjCGCStrong(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isObjCGCStrong();
}

CXQualifiers_ObjCLifetime clang_QualType_getObjCLifetime(CXQualType OpaquePtr) {
  return static_cast<CXQualifiers_ObjCLifetime>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getObjCLifetime());
}

bool clang_QualType_hasNonTrivialObjCLifetime(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasNonTrivialObjCLifetime();
}

bool clang_QualType_hasStrongOrWeakObjCLifetime(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasStrongOrWeakObjCLifetime();
}

bool clang_QualType_isNonWeakInMRRWithObjCWeak(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isNonWeakInMRRWithObjCWeak(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isAtLeastAsQualifiedAs(CXQualType OpaquePtr, CXQualType Other) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isAtLeastAsQualifiedAs(
      clang::QualType::getFromOpaquePtr(Other));
}

CXQualType clang_QualType_getNonReferenceType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getNonReferenceType()
      .getAsOpaquePtr());
}

CXQualType clang_QualType_getNonPackExpansionType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getNonPackExpansionType()
      .getAsOpaquePtr());
}

CXQualType clang_QualType_IgnoreParens(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).IgnoreParens().getAsOpaquePtr());
}

CXQualType clang_QualType_getDesugaredType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getDesugaredType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

CXQualType clang_QualType_getSingleStepDesugaredType(CXQualType OpaquePtr,
                                                     CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getSingleStepDesugaredType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

bool clang_QualType_isConstant(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isConstant(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isNonConstantStorage(CXQualType OpaquePtr, CXASTContext Ctx,
                                         bool ExcludeCtor, bool ExcludeDtor,
                                         CXNonConstantStorageReason *Out) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  auto R = T.isNonConstantStorage(*reinterpret_cast<clang::ASTContext *>(Ctx), ExcludeCtor,
                                  ExcludeDtor);
  if (!R)
    return false;
  *Out = static_cast<CXNonConstantStorageReason>(*R);
  return true;
}

// isConstantStorage is a non-const member, so the QualType is rebuilt into a
// local lvalue before the call.
bool clang_QualType_isConstantStorage(CXQualType OpaquePtr, CXASTContext Ctx,
                                      bool ExcludeCtor, bool ExcludeDtor) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(OpaquePtr);
  return T.isConstantStorage(*reinterpret_cast<clang::ASTContext *>(Ctx), ExcludeCtor,
                             ExcludeDtor);
}

bool clang_QualType_isPODType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isPODType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isCXX98PODType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCXX98PODType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isCXX11PODType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCXX11PODType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isTrivialType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isTrivialType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isTriviallyCopyableType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isTriviallyCopyableType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isTriviallyCopyConstructibleType(CXQualType OpaquePtr,
                                                     CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isTriviallyCopyConstructibleType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isTriviallyRelocatableType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isTriviallyRelocatableType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_QualType_isTriviallyEqualityComparableType(CXQualType OpaquePtr,
                                                      CXASTContext Ctx) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isTriviallyEqualityComparableType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

CXString clang_QualType_getAsString(CXQualType OpaquePtr) {
  return extra::makeCXString(clang::QualType::getFromOpaquePtr(OpaquePtr).getAsString());
}

CXString clang_QualType_printAsString(CXQualType OpaquePtr, CXASTContext Ctx,
                                      const char *PlaceHolder, unsigned Indentation) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::QualType::getFromOpaquePtr(OpaquePtr).print(OS, C->getPrintingPolicy(),
                                                     PlaceHolder, Indentation);
  return extra::makeCXString(Str);
}

CXString clang_QualType_dumpToString(CXQualType OpaquePtr, CXASTContext Ctx) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::QualType::getFromOpaquePtr(OpaquePtr).dump(
      OS, *reinterpret_cast<clang::ASTContext *>(Ctx));
  return extra::makeCXString(OS.str());
}

CXString clang_QualType_getAsStringWithPolicy(CXQualType OpaquePtr,
                                              CXPrintingPolicy_ Policy) {
  return extra::makeCXString(clang::QualType::getFromOpaquePtr(OpaquePtr).getAsString(
      *reinterpret_cast<clang::PrintingPolicy *>(Policy)));
}

CXString clang_QualType_printAsStringWithPolicy(CXQualType OpaquePtr,
                                                CXPrintingPolicy_ Policy,
                                                const char *PlaceHolder,
                                                unsigned Indentation) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::QualType::getFromOpaquePtr(OpaquePtr).print(
      OS, *reinterpret_cast<clang::PrintingPolicy *>(Policy), PlaceHolder, Indentation);
  return extra::makeCXString(Str);
}

void clang_QualType_dump(CXQualType OpaquePtr) {
  clang::QualType::getFromOpaquePtr(OpaquePtr).dump();
}

CXQualType clang_QualType_getCanonicalType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).getCanonicalType().getAsOpaquePtr());
}

CXQualType clang_QualType_getLocalUnqualifiedType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getLocalUnqualifiedType()
      .getAsOpaquePtr());
}

CXQualType clang_QualType_getUnqualifiedType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr).getUnqualifiedType().getAsOpaquePtr());
}

CXIdentifierInfo clang_QualType_getBaseTypeIdentifier(CXQualType OpaquePtr) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).getBaseTypeIdentifier()));
}

bool clang_QualType_isReferenceable(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isReferenceable();
}

unsigned clang_QualType_getLocalQualifiers(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getLocalQualifiers()
      .getAsOpaqueValue();
}

bool clang_QualType_mayBeDynamicClass(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).mayBeDynamicClass();
}

bool clang_QualType_mayBeNotDynamicClass(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).mayBeNotDynamicClass();
}

bool clang_QualType_isWebAssemblyReferenceType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isWebAssemblyReferenceType();
}

bool clang_QualType_isWebAssemblyExternrefType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isWebAssemblyExternrefType();
}

bool clang_QualType_isWebAssemblyFuncrefType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isWebAssemblyFuncrefType();
}

CXQualType clang_QualType_stripObjCKindOfType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .stripObjCKindOfType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

CXQualType clang_QualType_getAtomicUnqualifiedType(CXQualType OpaquePtr) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getAtomicUnqualifiedType()
      .getAsOpaquePtr());
}

CXPrimitiveDefaultInitializeKind
clang_QualType_isNonTrivialToPrimitiveDefaultInitialize(CXQualType OpaquePtr) {
  return static_cast<CXPrimitiveDefaultInitializeKind>(
      clang::QualType::getFromOpaquePtr(OpaquePtr)
          .isNonTrivialToPrimitiveDefaultInitialize());
}

CXPrimitiveCopyKind clang_QualType_isNonTrivialToPrimitiveCopy(CXQualType OpaquePtr) {
  return static_cast<CXPrimitiveCopyKind>(
      clang::QualType::getFromOpaquePtr(OpaquePtr).isNonTrivialToPrimitiveCopy());
}

CXPrimitiveCopyKind
clang_QualType_isNonTrivialToPrimitiveDestructiveMove(CXQualType OpaquePtr) {
  return static_cast<CXPrimitiveCopyKind>(clang::QualType::getFromOpaquePtr(OpaquePtr)
                                              .isNonTrivialToPrimitiveDestructiveMove());
}

bool clang_QualType_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr)
      .hasNonTrivialToPrimitiveDefaultInitializeCUnion();
}

bool clang_QualType_hasNonTrivialToPrimitiveDestructCUnion(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr)
      .hasNonTrivialToPrimitiveDestructCUnion();
}

bool clang_QualType_hasNonTrivialToPrimitiveCopyCUnion(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).hasNonTrivialToPrimitiveCopyCUnion();
}

bool clang_QualType_isCForbiddenLValueType(CXQualType OpaquePtr) {
  return clang::QualType::getFromOpaquePtr(OpaquePtr).isCForbiddenLValueType();
}

CXQualType clang_QualType_getNonLValueExprType(CXQualType OpaquePtr, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(clang::QualType::getFromOpaquePtr(OpaquePtr)
      .getNonLValueExprType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

// Type
bool clang_Type_isFromAST(CXType_ T) { return reinterpret_cast<clang::Type *>(T)->isFromAST(); }

bool clang_Type_isCanonicalUnqualified(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCanonicalUnqualified();
}

bool clang_Type_isSizelessType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSizelessType();
}

bool clang_Type_isSizelessBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSizelessBuiltinType();
}

bool clang_Type_isSizelessVectorType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSizelessVectorType();
}

bool clang_Type_isSVESizelessBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSVESizelessBuiltinType();
}

bool clang_Type_isRVVSizelessBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRVVSizelessBuiltinType();
}

bool clang_Type_isWebAssemblyExternrefType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isWebAssemblyExternrefType();
}

bool clang_Type_isWebAssemblyTableType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isWebAssemblyTableType();
}

bool clang_Type_isSveVLSBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSveVLSBuiltinType();
}

CXQualType clang_Type_getSveEltType(CXType_ T, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Type *>(T)
      ->getSveEltType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

bool clang_Type_isRVVVLSBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRVVVLSBuiltinType();
}

CXQualType clang_Type_getRVVEltType(CXType_ T, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Type *>(T)
      ->getRVVEltType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

bool clang_Type_isLiteralType(CXType_ T, CXASTContext Ctx) {
  return reinterpret_cast<clang::Type *>(T)->isLiteralType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Type_isStructuralType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isStructuralType();
}

bool clang_Type_isStandardLayoutType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isStandardLayoutType();
}

bool clang_Type_isBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isBuiltinType();
}

bool clang_Type_isSpecificBuiltinType(CXType_ T, unsigned K) {
  return reinterpret_cast<clang::Type *>(T)->isSpecificBuiltinType(K);
}

bool clang_Type_isIntegerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIntegerType();
}

bool clang_Type_isEnumeralType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isEnumeralType();
}

bool clang_Type_isScopedEnumeralType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isScopedEnumeralType();
}

bool clang_Type_isBooleanType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isBooleanType();
}

bool clang_Type_isCharType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCharType();
}

bool clang_Type_isWideCharType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isWideCharType();
}

bool clang_Type_isChar8Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isChar8Type();
}

bool clang_Type_isChar16Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isChar16Type();
}

bool clang_Type_isChar32Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isChar32Type();
}

bool clang_Type_isAnyCharacterType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAnyCharacterType();
}

bool clang_Type_isIntegralOrEnumerationType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIntegralOrEnumerationType();
}

bool clang_Type_isIntegralOrUnscopedEnumerationType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIntegralOrUnscopedEnumerationType();
}

bool clang_Type_isUnscopedEnumerationType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnscopedEnumerationType();
}

bool clang_Type_isRealFloatingType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRealFloatingType();
}

bool clang_Type_isComplexType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isComplexType();
}

bool clang_Type_isAnyComplexType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAnyComplexType();
}

bool clang_Type_isFloatingType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFloatingType();
}

bool clang_Type_isHalfType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isHalfType();
}

bool clang_Type_isFloat16Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFloat16Type();
}

bool clang_Type_isBFloat16Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isBFloat16Type();
}

bool clang_Type_isFloat128Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFloat128Type();
}

bool clang_Type_isIbm128Type(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIbm128Type();
}

bool clang_Type_isRealType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRealType();
}

bool clang_Type_isArithmeticType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isArithmeticType();
}

bool clang_Type_isVoidType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVoidType();
}

bool clang_Type_isScalarType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isScalarType();
}

bool clang_Type_isAggregateType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAggregateType();
}

bool clang_Type_isFundamentalType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFundamentalType();
}

bool clang_Type_isCompoundType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCompoundType();
}

bool clang_Type_isFunctionType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFunctionType();
}

bool clang_Type_isFunctionNoProtoType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFunctionNoProtoType();
}

bool clang_Type_isFunctionProtoType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFunctionProtoType();
}

bool clang_Type_isPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isPointerType();
}

bool clang_Type_isAnyPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAnyPointerType();
}

bool clang_Type_isBlockPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isBlockPointerType();
}

bool clang_Type_isVoidPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVoidPointerType();
}

bool clang_Type_isReferenceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isReferenceType();
}

bool clang_Type_isLValueReferenceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isLValueReferenceType();
}

bool clang_Type_isRValueReferenceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRValueReferenceType();
}

bool clang_Type_isObjectPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjectPointerType();
}

bool clang_Type_isFunctionPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFunctionPointerType();
}

bool clang_Type_isFunctionReferenceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFunctionReferenceType();
}

bool clang_Type_isMemberPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isMemberPointerType();
}

bool clang_Type_isMemberFunctionPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isMemberFunctionPointerType();
}

bool clang_Type_isMemberDataPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isMemberDataPointerType();
}

bool clang_Type_isArrayType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isArrayType();
}

bool clang_Type_isConstantArrayType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isConstantArrayType();
}

bool clang_Type_isIncompleteArrayType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIncompleteArrayType();
}

bool clang_Type_isVariableArrayType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVariableArrayType();
}

bool clang_Type_isDependentSizedArrayType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isDependentSizedArrayType();
}

bool clang_Type_isRecordType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isRecordType();
}

bool clang_Type_isClassType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isClassType();
}

bool clang_Type_isStructureType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isStructureType();
}

bool clang_Type_isObjCBoxableRecordType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCBoxableRecordType();
}

bool clang_Type_isInterfaceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isInterfaceType();
}

bool clang_Type_isStructureOrClassType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isStructureOrClassType();
}

bool clang_Type_isUnionType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnionType();
}

bool clang_Type_isComplexIntegerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isComplexIntegerType();
}

bool clang_Type_isVectorType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVectorType();
}

bool clang_Type_isExtVectorType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isExtVectorType();
}

bool clang_Type_isExtVectorBoolType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isExtVectorBoolType();
}

bool clang_Type_isMatrixType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isMatrixType();
}

bool clang_Type_isConstantMatrixType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isConstantMatrixType();
}

bool clang_Type_isDependentAddressSpaceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isDependentAddressSpaceType();
}

bool clang_Type_isObjCObjectPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCObjectPointerType();
}

bool clang_Type_isObjCRetainableType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCRetainableType();
}

bool clang_Type_isObjCLifetimeType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCLifetimeType();
}

bool clang_Type_isObjCIndirectLifetimeType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCIndirectLifetimeType();
}

bool clang_Type_isObjCNSObjectType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCNSObjectType();
}

bool clang_Type_isObjCIndependentClassType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCIndependentClassType();
}

bool clang_Type_isObjCObjectType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCObjectType();
}

bool clang_Type_isObjCQualifiedInterfaceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCQualifiedInterfaceType();
}

bool clang_Type_isObjCQualifiedIdType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCQualifiedIdType();
}

bool clang_Type_isObjCQualifiedClassType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCQualifiedClassType();
}

bool clang_Type_isObjCObjectOrInterfaceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCObjectOrInterfaceType();
}

bool clang_Type_isObjCIdType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCIdType();
}

bool clang_Type_isDecltypeType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isDecltypeType();
}

bool clang_Type_isObjCInertUnsafeUnretainedType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCInertUnsafeUnretainedType();
}

bool clang_Type_isObjCIdOrObjectKindOfType(CXType_ T, CXASTContext Ctx,
                                           CXObjCObjectType *Bound) {
  const clang::ObjCObjectType *B = nullptr;
  bool Matched = reinterpret_cast<clang::Type *>(T)->isObjCIdOrObjectKindOfType(
      *reinterpret_cast<clang::ASTContext *>(Ctx), B);
  if (Bound)
    *Bound = reinterpret_cast<CXObjCObjectType>(const_cast<clang::ObjCObjectType *>(B));
  return Matched;
}

bool clang_Type_isObjCClassType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCClassType();
}

bool clang_Type_isObjCClassOrClassKindOfType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCClassOrClassKindOfType();
}

bool clang_Type_isBlockCompatibleObjCPointerType(CXType_ T, CXASTContext Ctx) {
  return reinterpret_cast<clang::Type *>(T)->isBlockCompatibleObjCPointerType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Type_isObjCSelType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCSelType();
}

bool clang_Type_isObjCBuiltinType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCBuiltinType();
}

bool clang_Type_isObjCARCBridgableType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCARCBridgableType();
}

bool clang_Type_isCARCBridgableType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCARCBridgableType();
}

bool clang_Type_isTemplateTypeParmType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isTemplateTypeParmType();
}

bool clang_Type_isNullPtrType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isNullPtrType();
}

bool clang_Type_isNothrowT(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isNothrowT();
}

bool clang_Type_isAlignValT(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAlignValT();
}

bool clang_Type_isStdByteType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isStdByteType();
}

bool clang_Type_isAtomicType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isAtomicType();
}

bool clang_Type_isUndeducedAutoType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUndeducedAutoType();
}

bool clang_Type_isTypedefNameType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isTypedefNameType();
}

bool clang_Type_isImageType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isImageType();
}

bool clang_Type_isSamplerT(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSamplerT();
}

bool clang_Type_isEventT(CXType_ T) { return reinterpret_cast<clang::Type *>(T)->isEventT(); }

bool clang_Type_isClkEventT(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isClkEventT();
}

bool clang_Type_isQueueT(CXType_ T) { return reinterpret_cast<clang::Type *>(T)->isQueueT(); }

bool clang_Type_isReserveIDT(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isReserveIDT();
}

bool clang_Type_isOCLIntelSubgroupAVCType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isOCLIntelSubgroupAVCType();
}

bool clang_Type_isOCLExtOpaqueType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isOCLExtOpaqueType();
}

bool clang_Type_isDependentType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isDependentType();
}

bool clang_Type_isInstantiationDependentType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isInstantiationDependentType();
}

bool clang_Type_isUndeducedType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUndeducedType();
}

bool clang_Type_isVariablyModifiedType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVariablyModifiedType();
}

bool clang_Type_hasSizedVLAType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasSizedVLAType();
}

bool clang_Type_hasUnnamedOrLocalType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasUnnamedOrLocalType();
}

bool clang_Type_isOverloadableType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isOverloadableType();
}

bool clang_Type_isElaboratedTypeSpecifier(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isElaboratedTypeSpecifier();
}

bool clang_Type_canDecayToPointerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->canDecayToPointerType();
}

bool clang_Type_hasPointerRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasPointerRepresentation();
}

bool clang_Type_hasObjCPointerRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasObjCPointerRepresentation();
}

bool clang_Type_hasIntegerRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasIntegerRepresentation();
}

bool clang_Type_hasSignedIntegerRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasSignedIntegerRepresentation();
}

bool clang_Type_hasUnsignedIntegerRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasUnsignedIntegerRepresentation();
}

bool clang_Type_hasFloatingRepresentation(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasFloatingRepresentation();
}

CXRecordType clang_Type_getAsStructureType(CXType_ T) {
  return reinterpret_cast<CXRecordType>(const_cast<clang::RecordType *>(
      reinterpret_cast<clang::Type *>(T)->getAsStructureType()));
}

CXRecordType clang_Type_getAsUnionType(CXType_ T) {
  return reinterpret_cast<CXRecordType>(const_cast<clang::RecordType *>(reinterpret_cast<clang::Type *>(T)->getAsUnionType()));
}

CXComplexType clang_Type_getAsComplexIntegerType(CXType_ T) {
  return reinterpret_cast<CXComplexType>(const_cast<clang::ComplexType *>(
      reinterpret_cast<clang::Type *>(T)->getAsComplexIntegerType()));
}

CXObjCObjectType clang_Type_getAsObjCInterfaceType(CXType_ T) {
  return reinterpret_cast<CXObjCObjectType>(const_cast<clang::ObjCObjectType *>(
      reinterpret_cast<clang::Type *>(T)->getAsObjCInterfaceType()));
}

CXObjCObjectPointerType clang_Type_getAsObjCInterfacePointerType(CXType_ T) {
  return reinterpret_cast<CXObjCObjectPointerType>(const_cast<clang::ObjCObjectPointerType *>(
      reinterpret_cast<clang::Type *>(T)->getAsObjCInterfacePointerType()));
}

CXObjCObjectPointerType clang_Type_getAsObjCQualifiedIdType(CXType_ T) {
  return reinterpret_cast<CXObjCObjectPointerType>(const_cast<clang::ObjCObjectPointerType *>(
      reinterpret_cast<clang::Type *>(T)->getAsObjCQualifiedIdType()));
}

CXObjCObjectPointerType clang_Type_getAsObjCQualifiedClassType(CXType_ T) {
  return reinterpret_cast<CXObjCObjectPointerType>(const_cast<clang::ObjCObjectPointerType *>(
      reinterpret_cast<clang::Type *>(T)->getAsObjCQualifiedClassType()));
}

CXObjCObjectType clang_Type_getAsObjCQualifiedInterfaceType(CXType_ T) {
  return reinterpret_cast<CXObjCObjectType>(const_cast<clang::ObjCObjectType *>(
      reinterpret_cast<clang::Type *>(T)->getAsObjCQualifiedInterfaceType()));
}

CXCXXRecordDecl clang_Type_getAsCXXRecordDecl(CXType_ T) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::Type *>(T)->getAsCXXRecordDecl());
}

CXRecordDecl clang_Type_getAsRecordDecl(CXType_ T) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::Type *>(T)->getAsRecordDecl());
}

CXTagDecl clang_Type_getAsTagDecl(CXType_ T) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::Type *>(T)->getAsTagDecl());
}

CXCXXRecordDecl clang_Type_getPointeeCXXRecordDecl(CXType_ T) {
  return reinterpret_cast<CXCXXRecordDecl>(const_cast<clang::CXXRecordDecl *>(
      reinterpret_cast<clang::Type *>(T)->getPointeeCXXRecordDecl()));
}

CXDeducedType clang_Type_getContainedDeducedType(CXType_ T) {
  return reinterpret_cast<CXDeducedType>(reinterpret_cast<clang::Type *>(T)->getContainedDeducedType());
}

CXAutoType clang_Type_getContainedAutoType(CXType_ T) {
  return reinterpret_cast<CXAutoType>(reinterpret_cast<clang::Type *>(T)->getContainedAutoType());
}

bool clang_Type_hasAutoForTrailingReturnType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->hasAutoForTrailingReturnType();
}

CXType_ clang_Type_getArrayElementTypeNoTypeQual(CXType_ T) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      reinterpret_cast<clang::Type *>(T)->getArrayElementTypeNoTypeQual()));
}

CXType_ clang_Type_getPointeeOrArrayElementType(CXType_ T) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      reinterpret_cast<clang::Type *>(T)->getPointeeOrArrayElementType()));
}

CXQualType clang_Type_getPointeeType(CXType_ T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Type *>(T)->getPointeeType().getAsOpaquePtr());
}

CXType_ clang_Type_getUnqualifiedDesugaredType(CXType_ T) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      reinterpret_cast<clang::Type *>(T)->getUnqualifiedDesugaredType()));
}

// bool clang_Type_isPromotableIntegerType(CXType_ T) {
//   return static_cast<clang::Type *>(T)->isPromotableIntegerType();
// }

bool clang_Type_isSignedIntegerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSignedIntegerType();
}

bool clang_Type_isUnsignedIntegerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnsignedIntegerType();
}

bool clang_Type_isSignedIntegerOrEnumerationType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSignedIntegerOrEnumerationType();
}

bool clang_Type_isUnsignedIntegerOrEnumerationType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnsignedIntegerOrEnumerationType();
}

bool clang_Type_isFixedPointType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFixedPointType();
}

bool clang_Type_isFixedPointOrIntegerType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isFixedPointOrIntegerType();
}

bool clang_Type_isSaturatedFixedPointType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSaturatedFixedPointType();
}

bool clang_Type_isUnsaturatedFixedPointType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnsaturatedFixedPointType();
}

bool clang_Type_isSignedFixedPointType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSignedFixedPointType();
}

bool clang_Type_isUnsignedFixedPointType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isUnsignedFixedPointType();
}

bool clang_Type_isConstantSizeType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isConstantSizeType();
}

bool clang_Type_isSpecifierType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isSpecifierType();
}

CXLinkage clang_Type_getLinkage(CXType_ T) {
  return static_cast<CXLinkage>(reinterpret_cast<clang::Type *>(T)->getLinkage());
}

CXVisibility clang_Type_getVisibility(CXType_ T) {
  return static_cast<CXVisibility>(reinterpret_cast<clang::Type *>(T)->getVisibility());
}

bool clang_Type_isVisibilityExplicit(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isVisibilityExplicit();
}

void clang_Type_getLinkageAndVisibility(CXType_ T, CXLinkage *L, CXVisibility *V,
                                        bool *VisibilityExplicit) {
  clang::LinkageInfo LV = reinterpret_cast<clang::Type *>(T)->getLinkageAndVisibility();
  *L = static_cast<CXLinkage>(LV.getLinkage());
  *V = static_cast<CXVisibility>(LV.getVisibility());
  *VisibilityExplicit = LV.isVisibilityExplicit();
}

bool clang_Type_isLinkageValid(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isLinkageValid();
}

bool clang_Type_canHaveNullability(CXType_ T, bool ResultIfUnknown) {
  return reinterpret_cast<clang::Type *>(T)->canHaveNullability(ResultIfUnknown);
}

bool clang_Type_getNullability(CXType_ T, CXNullabilityKind *Out) {
  if (auto NK = reinterpret_cast<clang::Type *>(T)->getNullability()) {
    *Out = static_cast<CXNullabilityKind>(*NK);
    return true;
  }
  return false;
}

CXQualType clang_Type_getCanonicalTypeInternal(CXType_ T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Type *>(T)->getCanonicalTypeInternal().getAsOpaquePtr());
}

CXQualType clang_Type_getCanonicalTypeUnqualified(CXType_ T) {
  clang::QualType QT = reinterpret_cast<clang::Type *>(T)->getCanonicalTypeUnqualified();
  return reinterpret_cast<CXQualType>(QT.getAsOpaquePtr());
}

void clang_Type_dump(CXType_ T) { return reinterpret_cast<clang::Type *>(T)->dump(); }

// Type: parameterised / ASTContext-taking queries and navigation helpers. Declared
// interleaved in CXType.h in clang::Type's own method order; grouped here.
bool clang_Type_containsUnexpandedParameterPack(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->containsUnexpandedParameterPack();
}

CXQualType clang_Type_getLocallyUnqualifiedSingleStepDesugaredType(CXType_ T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Type *>(T)
      ->getLocallyUnqualifiedSingleStepDesugaredType()
      .getAsOpaquePtr());
}

bool clang_Type_isIncompleteType(CXType_ T, CXNamedDecl *Def) {
  clang::NamedDecl *D = nullptr;
  bool R = reinterpret_cast<clang::Type *>(T)->isIncompleteType(Def ? &D : nullptr);
  if (Def)
    *Def = reinterpret_cast<CXNamedDecl>(D);
  return R;
}

bool clang_Type_isIncompleteOrObjectType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isIncompleteOrObjectType();
}

bool clang_Type_isObjectType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjectType();
}

bool clang_Type_isPlaceholderType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isPlaceholderType();
}

CXBuiltinType clang_Type_getAsPlaceholderType(CXType_ T) {
  return reinterpret_cast<CXBuiltinType>(const_cast<clang::BuiltinType *>(
      reinterpret_cast<clang::Type *>(T)->getAsPlaceholderType()));
}

bool clang_Type_isSpecificPlaceholderType(CXType_ T, unsigned K) {
  return reinterpret_cast<clang::Type *>(T)->isSpecificPlaceholderType(K);
}

bool clang_Type_isNonOverloadPlaceholderType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isNonOverloadPlaceholderType();
}

bool clang_Type_isIntegralType(CXType_ T, CXASTContext Ctx) {
  return reinterpret_cast<clang::Type *>(T)->isIntegralType(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Type_isPipeType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isPipeType();
}

bool clang_Type_isBitIntType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isBitIntType();
}

bool clang_Type_isOpenCLSpecificType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isOpenCLSpecificType();
}

bool clang_Type_isObjCARCImplicitlyUnretainedType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isObjCARCImplicitlyUnretainedType();
}

bool clang_Type_isCUDADeviceBuiltinSurfaceType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCUDADeviceBuiltinSurfaceType();
}

bool clang_Type_isCUDADeviceBuiltinTextureType(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->isCUDADeviceBuiltinTextureType();
}

CXQualifiers_ObjCLifetime clang_Type_getObjCARCImplicitLifetime(CXType_ T) {
  return static_cast<CXQualifiers_ObjCLifetime>(
      reinterpret_cast<clang::Type *>(T)->getObjCARCImplicitLifetime());
}

CXScalarTypeKind clang_Type_getScalarTypeKind(CXType_ T) {
  return static_cast<CXScalarTypeKind>(
      reinterpret_cast<clang::Type *>(T)->getScalarTypeKind());
}

unsigned clang_Type_getDependence(CXType_ T) {
  return static_cast<unsigned>(reinterpret_cast<clang::Type *>(T)->getDependence());
}

bool clang_Type_containsErrors(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->containsErrors();
}

CXArrayType clang_Type_getAsArrayTypeUnsafe(CXType_ T) {
  return reinterpret_cast<CXArrayType>(const_cast<clang::ArrayType *>(
      reinterpret_cast<clang::Type *>(T)->getAsArrayTypeUnsafe()));
}

CXArrayType clang_Type_castAsArrayTypeUnsafe(CXType_ T) {
  return reinterpret_cast<CXArrayType>(const_cast<clang::ArrayType *>(
      reinterpret_cast<clang::Type *>(T)->castAsArrayTypeUnsafe()));
}

bool clang_Type_hasAttr(CXType_ T, CXAttrKind AK) {
  return reinterpret_cast<clang::Type *>(T)->hasAttr(static_cast<clang::attr::Kind>(AK));
}

CXType_ clang_Type_getBaseElementTypeUnsafe(CXType_ T) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      reinterpret_cast<clang::Type *>(T)->getBaseElementTypeUnsafe()));
}

bool clang_Type_acceptsObjCTypeParams(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->acceptsObjCTypeParams();
}

const char *clang_Type_getTypeClassName(CXType_ T) {
  return reinterpret_cast<clang::Type *>(T)->getTypeClassName();
}

// isa
bool clang_isa_ComplexType(CXType_ T) {
  return llvm::isa<clang::ComplexType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_PointerType(CXType_ T) {
  return llvm::isa<clang::PointerType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_ReferenceType(CXType_ T) {
  return llvm::isa<clang::ReferenceType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_LValueReferenceType(CXType_ T) {
  return llvm::isa<clang::LValueReferenceType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_RValueReferenceType(CXType_ T) {
  return llvm::isa<clang::RValueReferenceType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_MemberPointerType(CXType_ T) {
  return llvm::isa<clang::MemberPointerType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_ArrayType(CXType_ T) {
  return llvm::isa<clang::ArrayType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_ConstantArrayType(CXType_ T) {
  return llvm::isa<clang::ConstantArrayType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_IncompleteArrayType(CXType_ T) {
  return llvm::isa<clang::IncompleteArrayType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_VariableArrayType(CXType_ T) {
  return llvm::isa<clang::VariableArrayType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentSizedArrayType(CXType_ T) {
  return llvm::isa<clang::DependentSizedArrayType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_FunctionType(CXType_ T) {
  return llvm::isa<clang::FunctionType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_FunctionNoProtoType(CXType_ T) {
  return llvm::isa<clang::FunctionNoProtoType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_FunctionProtoType(CXType_ T) {
  return llvm::isa<clang::FunctionProtoType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_UnresolvedUsingType(CXType_ T) {
  return llvm::isa<clang::UnresolvedUsingType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_UsingType(CXType_ T) {
  return llvm::isa<clang::UsingType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_TypedefType(CXType_ T) {
  return llvm::isa<clang::TypedefType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DecltypeType(CXType_ T) {
  return llvm::isa<clang::DecltypeType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentDecltypeType(CXType_ T) {
  return llvm::isa<clang::DependentDecltypeType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_TagType(CXType_ T) {
  return llvm::isa<clang::TagType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_RecordType(CXType_ T) {
  return llvm::isa<clang::RecordType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_EnumType(CXType_ T) {
  return llvm::isa<clang::EnumType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_TemplateTypeParmType(CXType_ T) {
  return llvm::isa<clang::TemplateTypeParmType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_SubstTemplateTypeParmType(CXType_ T) {
  return llvm::isa<clang::SubstTemplateTypeParmType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_SubstTemplateTypeParmPackType(CXType_ T) {
  return llvm::isa<clang::SubstTemplateTypeParmPackType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DeducedType(CXType_ T) {
  return llvm::isa<clang::DeducedType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_AutoType(CXType_ T) {
  return llvm::isa<clang::AutoType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DeducedTemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::DeducedTemplateSpecializationType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_TemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::TemplateSpecializationType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_ElaboratedType(CXType_ T) {
  return llvm::isa<clang::ElaboratedType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentNameType(CXType_ T) {
  return llvm::isa<clang::DependentNameType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentTemplateSpecializationType(CXType_ T) {
  return llvm::isa<clang::DependentTemplateSpecializationType>(
      reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_AtomicType(CXType_ T) {
  return llvm::isa<clang::AtomicType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DecayedType(CXType_ T) {
  return llvm::isa<clang::DecayedType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_AdjustedType(CXType_ T) {
  return llvm::isa<clang::AdjustedType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_InjectedClassNameType(CXType_ T) {
  return llvm::isa<clang::InjectedClassNameType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_MacroQualifiedType(CXType_ T) {
  return llvm::isa<clang::MacroQualifiedType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_UnaryTransformType(CXType_ T) {
  return llvm::isa<clang::UnaryTransformType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_ParenType(CXType_ T) {
  return llvm::isa<clang::ParenType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentAddressSpaceType(CXType_ T) {
  return llvm::isa<clang::DependentAddressSpaceType>(reinterpret_cast<clang::Type *>(T));
}

bool clang_isa_DependentSizedExtVectorType(CXType_ T) {
  return llvm::isa<clang::DependentSizedExtVectorType>(reinterpret_cast<clang::Type *>(T));
}

// BuiltinTypes
bool clang_isa_BuiltinType_Void(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Void;
}

bool clang_isa_BuiltinType_Bool(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Bool;
}

bool clang_isa_BuiltinType_Char_U(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char_U;
}

bool clang_isa_BuiltinType_UChar(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UChar;
}

bool clang_isa_BuiltinType_WChar_U(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::WChar_U;
}

bool clang_isa_BuiltinType_Char8(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char8;
}

bool clang_isa_BuiltinType_Char16(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char16;
}

bool clang_isa_BuiltinType_Char32(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char32;
}

bool clang_isa_BuiltinType_UShort(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UShort;
}

bool clang_isa_BuiltinType_UInt(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UInt;
}

bool clang_isa_BuiltinType_ULong(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::ULong;
}

bool clang_isa_BuiltinType_ULongLong(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::ULongLong;
}

bool clang_isa_BuiltinType_UInt128(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::UInt128;
}

bool clang_isa_BuiltinType_Char_S(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Char_S;
}

bool clang_isa_BuiltinType_SChar(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::SChar;
}

bool clang_isa_BuiltinType_WChar_S(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::WChar_S;
}

bool clang_isa_BuiltinType_Short(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Short;
}

bool clang_isa_BuiltinType_Int(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Int;
}

bool clang_isa_BuiltinType_Long(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Long;
}

bool clang_isa_BuiltinType_LongLong(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::LongLong;
}

bool clang_isa_BuiltinType_Int128(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Int128;
}

bool clang_isa_BuiltinType_Half(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Half;
}

bool clang_isa_BuiltinType_Float(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float;
}

bool clang_isa_BuiltinType_Double(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Double;
}

bool clang_isa_BuiltinType_LongDouble(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::LongDouble;
}

bool clang_isa_BuiltinType_Float16(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float16;
}

bool clang_isa_BuiltinType_BFloat16(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::BFloat16;
}

bool clang_isa_BuiltinType_Float128(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::Float128;
}

bool clang_isa_BuiltinType_NullPtr(CXType_ T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind() == clang::BuiltinType::NullPtr;
}

bool clang_BuiltinType_isSugared(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isSugared();
}

CXQualType clang_BuiltinType_desugar(CXBuiltinType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::BuiltinType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_BuiltinType_isInteger(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isInteger();
}

bool clang_BuiltinType_isSignedInteger(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isSignedInteger();
}

bool clang_BuiltinType_isUnsignedInteger(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isUnsignedInteger();
}

bool clang_BuiltinType_isFloatingPoint(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isFloatingPoint();
}

bool clang_BuiltinType_isSVEBool(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isSVEBool();
}

bool clang_BuiltinType_isSVECount(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isSVECount();
}

bool clang_BuiltinType_isPlaceholderTypeKind(unsigned K) {
  clang::BuiltinType::Kind Kind = static_cast<clang::BuiltinType::Kind>(K);
  return clang::BuiltinType::isPlaceholderTypeKind(Kind);
}

unsigned clang_BuiltinType_getKind(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->getKind();
}

CXString clang_BuiltinType_getName(CXBuiltinType T, CXASTContext Ctx) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  llvm::StringRef Name =
      reinterpret_cast<clang::BuiltinType *>(T)->getName(C->getPrintingPolicy());
  return extra::makeCXString(Name.str());
}

const char *clang_BuiltinType_getNameAsCString(CXBuiltinType T, CXASTContext Ctx) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  return reinterpret_cast<clang::BuiltinType *>(T)->getNameAsCString(C->getPrintingPolicy());
}

bool clang_BuiltinType_isPlaceholderType(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isPlaceholderType();
}

bool clang_BuiltinType_isNonOverloadPlaceholderType(CXBuiltinType T) {
  return reinterpret_cast<clang::BuiltinType *>(T)->isNonOverloadPlaceholderType();
}

// ComplexType
CXQualType clang_ComplexType_getElementType(CXComplexType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ComplexType *>(T)->getElementType().getAsOpaquePtr());
}

bool clang_ComplexType_isSugared(CXComplexType T) {
  return reinterpret_cast<clang::ComplexType *>(T)->isSugared();
}

CXQualType clang_ComplexType_desugar(CXComplexType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ComplexType *>(T)->desugar().getAsOpaquePtr());
}

// ParenType
CXQualType clang_ParenType_getInnerType(CXParenType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ParenType *>(T)->getInnerType().getAsOpaquePtr());
}

bool clang_ParenType_isSugared(CXParenType T) {
  return reinterpret_cast<clang::ParenType *>(T)->isSugared();
}

CXQualType clang_ParenType_desugar(CXParenType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ParenType *>(T)->desugar().getAsOpaquePtr());
}

// PointerType
CXQualType clang_PointerType_getPointeeType(CXPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PointerType *>(T)->getPointeeType().getAsOpaquePtr());
}

bool clang_PointerType_isSugared(CXPointerType T) {
  return reinterpret_cast<clang::PointerType *>(T)->isSugared();
}

CXQualType clang_PointerType_desugar(CXPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PointerType *>(T)->desugar().getAsOpaquePtr());
}

// AdjustedType
CXQualType clang_AdjustedType_getOriginalType(CXAdjustedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AdjustedType *>(T)->getOriginalType().getAsOpaquePtr());
}

CXQualType clang_AdjustedType_getAdjustedType(CXAdjustedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AdjustedType *>(T)->getAdjustedType().getAsOpaquePtr());
}

bool clang_AdjustedType_isSugared(CXAdjustedType T) {
  return reinterpret_cast<clang::AdjustedType *>(T)->isSugared();
}

CXQualType clang_AdjustedType_desugar(CXAdjustedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AdjustedType *>(T)->desugar().getAsOpaquePtr());
}

// DecayedType
CXQualType clang_DecayedType_getDecayedType(CXDecayedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DecayedType *>(T)->getDecayedType().getAsOpaquePtr());
}

CXQualType clang_DecayedType_getPointeeType(CXDecayedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DecayedType *>(T)->getPointeeType().getAsOpaquePtr());
}

// BlockPointerType
CXQualType clang_BlockPointerType_getPointeeType(CXBlockPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::BlockPointerType *>(T)->getPointeeType().getAsOpaquePtr());
}

bool clang_BlockPointerType_isSugared(CXBlockPointerType T) {
  return reinterpret_cast<clang::BlockPointerType *>(T)->isSugared();
}

CXQualType clang_BlockPointerType_desugar(CXBlockPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::BlockPointerType *>(T)->desugar().getAsOpaquePtr());
}

// ReferenceType
bool clang_ReferenceType_isSpelledAsLValue(CXReferenceType T) {
  return reinterpret_cast<clang::ReferenceType *>(T)->isSpelledAsLValue();
}

bool clang_ReferenceType_isInnerRef(CXReferenceType T) {
  return reinterpret_cast<clang::ReferenceType *>(T)->isInnerRef();
}

CXQualType clang_ReferenceType_getPointeeTypeAsWritten(CXReferenceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ReferenceType *>(T)->getPointeeTypeAsWritten().getAsOpaquePtr());
}

CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ReferenceType *>(T)->getPointeeType().getAsOpaquePtr());
}

// LValueReferenceType
bool clang_LValueReferenceType_isSugared(CXLValueReferenceType T) {
  return reinterpret_cast<clang::LValueReferenceType *>(T)->isSugared();
}

CXQualType clang_LValueReferenceType_desugar(CXLValueReferenceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::LValueReferenceType *>(T)->desugar().getAsOpaquePtr());
}

// RValueReferenceType
bool clang_RValueReferenceType_isSugared(CXRValueReferenceType T) {
  return reinterpret_cast<clang::RValueReferenceType *>(T)->isSugared();
}

CXQualType clang_RValueReferenceType_desugar(CXRValueReferenceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::RValueReferenceType *>(T)->desugar().getAsOpaquePtr());
}

// MemberPointerType
CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MemberPointerType *>(T)->getPointeeType().getAsOpaquePtr());
}

bool clang_MemberPointerType_isMemberFunctionPointer(CXMemberPointerType T) {
  return reinterpret_cast<clang::MemberPointerType *>(T)->isMemberFunctionPointer();
}

bool clang_MemberPointerType_isMemberDataPointer(CXMemberPointerType T) {
  return reinterpret_cast<clang::MemberPointerType *>(T)->isMemberDataPointer();
}

CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(reinterpret_cast<clang::MemberPointerType *>(T)->getClass()));
}

CXCXXRecordDecl clang_MemberPointerType_getMostRecentCXXRecordDecl(CXMemberPointerType T) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::MemberPointerType *>(T)->getMostRecentCXXRecordDecl());
}

bool clang_MemberPointerType_isSugared(CXMemberPointerType T) {
  return reinterpret_cast<clang::MemberPointerType *>(T)->isSugared();
}

CXQualType clang_MemberPointerType_desugar(CXMemberPointerType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MemberPointerType *>(T)->desugar().getAsOpaquePtr());
}

// ArrayType
CXQualType clang_ArrayType_getElementType(CXArrayType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ArrayType *>(T)->getElementType().getAsOpaquePtr());
}

CXArraySizeModifier clang_ArrayType_getSizeModifier(CXArrayType T) {
  return static_cast<CXArraySizeModifier>(
      reinterpret_cast<clang::ArrayType *>(T)->getSizeModifier());
}

unsigned clang_ArrayType_getIndexTypeCVRQualifiers(CXArrayType T) {
  return reinterpret_cast<clang::ArrayType *>(T)->getIndexTypeCVRQualifiers();
}

unsigned clang_ArrayType_getIndexTypeQualifiers(CXArrayType T) {
  return reinterpret_cast<clang::ArrayType *>(T)->getIndexTypeQualifiers().getAsOpaqueValue();
}

// ConstantArrayType
LLVMGenericValueRef clang_ConstantArrayType_getSize(CXConstantArrayType T) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::ConstantArrayType *>(T)->getSize();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}
unsigned long long clang_ConstantArrayType_getZExtSize(CXConstantArrayType T) {
  return reinterpret_cast<clang::ConstantArrayType *>(T)->getSize().getZExtValue();
}

CXExpr clang_ConstantArrayType_getSizeExpr(CXConstantArrayType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::ConstantArrayType *>(T)->getSizeExpr()));
}

bool clang_ConstantArrayType_isSugared(CXConstantArrayType T) {
  return reinterpret_cast<clang::ConstantArrayType *>(T)->isSugared();
}

CXQualType clang_ConstantArrayType_desugar(CXConstantArrayType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ConstantArrayType *>(T)->desugar().getAsOpaquePtr());
}

unsigned clang_ConstantArrayType_getNumAddressingBits(CXConstantArrayType T,
                                                      CXASTContext C) {
  return reinterpret_cast<clang::ConstantArrayType *>(T)->getNumAddressingBits(
      *reinterpret_cast<clang::ASTContext *>(C));
}

unsigned clang_ConstantArrayType_getMaxSizeBits(CXASTContext C) {
  return clang::ConstantArrayType::getMaxSizeBits(*reinterpret_cast<clang::ASTContext *>(C));
}

// IncompleteArrayType
bool clang_IncompleteArrayType_isSugared(CXIncompleteArrayType T) {
  return reinterpret_cast<clang::IncompleteArrayType *>(T)->isSugared();
}

CXQualType clang_IncompleteArrayType_desugar(CXIncompleteArrayType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::IncompleteArrayType *>(T)->desugar().getAsOpaquePtr());
}

// VariableArrayType
CXSourceRange_ clang_VariableArrayType_getBracketsRange(CXVariableArrayType T) {
  auto rng = reinterpret_cast<clang::VariableArrayType *>(T)->getBracketsRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_VariableArrayType_getLBracketLoc(CXVariableArrayType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::VariableArrayType *>(T)->getLBracketLoc().getPtrEncoding());
}

CXSourceLocation_ clang_VariableArrayType_getRBracketLoc(CXVariableArrayType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::VariableArrayType *>(T)->getRBracketLoc().getPtrEncoding());
}
CXExpr clang_VariableArrayType_getSizeExpr(CXVariableArrayType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::VariableArrayType *>(T)->getSizeExpr()));
}

bool clang_VariableArrayType_isSugared(CXVariableArrayType T) {
  return reinterpret_cast<clang::VariableArrayType *>(T)->isSugared();
}

CXQualType clang_VariableArrayType_desugar(CXVariableArrayType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::VariableArrayType *>(T)->desugar().getAsOpaquePtr());
}

// DependentSizedArrayType
CXSourceRange_
clang_DependentSizedArrayType_getBracketsRange(CXDependentSizedArrayType T) {
  auto rng = reinterpret_cast<clang::DependentSizedArrayType *>(T)->getBracketsRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_
clang_DependentSizedArrayType_getLBracketLoc(CXDependentSizedArrayType T) {
  auto Loc = reinterpret_cast<clang::DependentSizedArrayType *>(T)->getLBracketLoc();
  return reinterpret_cast<CXSourceLocation_>(Loc.getPtrEncoding());
}

CXSourceLocation_
clang_DependentSizedArrayType_getRBracketLoc(CXDependentSizedArrayType T) {
  auto Loc = reinterpret_cast<clang::DependentSizedArrayType *>(T)->getRBracketLoc();
  return reinterpret_cast<CXSourceLocation_>(Loc.getPtrEncoding());
}
CXExpr clang_DependentSizedArrayType_getSizeExpr(CXDependentSizedArrayType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::DependentSizedArrayType *>(T)->getSizeExpr()));
}

bool clang_DependentSizedArrayType_isSugared(CXDependentSizedArrayType T) {
  return reinterpret_cast<clang::DependentSizedArrayType *>(T)->isSugared();
}

CXQualType clang_DependentSizedArrayType_desugar(CXDependentSizedArrayType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentSizedArrayType *>(T)->desugar().getAsOpaquePtr());
}

// DepedentAddressSpaceType
CXExpr clang_DependentAddressSpaceType_getAddrSpaceExpr(CXDependentAddressSpaceType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::DependentAddressSpaceType *>(T)->getAddrSpaceExpr()));
}

CXQualType clang_DependentAddressSpaceType_getPointeeType(CXDependentAddressSpaceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentAddressSpaceType *>(T)
      ->getPointeeType()
      .getAsOpaquePtr());
}

CXSourceLocation_
clang_DependentAddressSpaceType_getAttributeLoc(CXDependentAddressSpaceType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DependentAddressSpaceType *>(T)
      ->getAttributeLoc()
      .getPtrEncoding());
}

bool clang_DependentAddressSpaceType_isSugared(CXDependentAddressSpaceType T) {
  return reinterpret_cast<clang::DependentAddressSpaceType *>(T)->isSugared();
}

CXQualType clang_DependentAddressSpaceType_desugar(CXDependentAddressSpaceType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentAddressSpaceType *>(T)->desugar().getAsOpaquePtr());
}

// DependentSizedExtVectorType
CXExpr clang_DependentSizedExtVectorType_getSizeExpr(CXDependentSizedExtVectorType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::DependentSizedExtVectorType *>(T)->getSizeExpr()));
}

CXQualType
clang_DependentSizedExtVectorType_getElementType(CXDependentSizedExtVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentSizedExtVectorType *>(T)
      ->getElementType()
      .getAsOpaquePtr());
}

CXSourceLocation_
clang_DependentSizedExtVectorType_getAttributeLoc(CXDependentSizedExtVectorType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DependentSizedExtVectorType *>(T)
      ->getAttributeLoc()
      .getPtrEncoding());
}

bool clang_DependentSizedExtVectorType_isSugared(CXDependentSizedExtVectorType T) {
  return reinterpret_cast<clang::DependentSizedExtVectorType *>(T)->isSugared();
}

CXQualType clang_DependentSizedExtVectorType_desugar(CXDependentSizedExtVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentSizedExtVectorType *>(T)->desugar().getAsOpaquePtr());
}

// FunctionType
// VectorType
CXQualType clang_VectorType_getElementType(CXVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::VectorType *>(T)->getElementType().getAsOpaquePtr());
}

unsigned clang_VectorType_getNumElements(CXVectorType T) {
  return reinterpret_cast<clang::VectorType *>(T)->getNumElements();
}

bool clang_VectorType_isSugared(CXVectorType T) {
  return reinterpret_cast<clang::VectorType *>(T)->isSugared();
}

CXQualType clang_VectorType_desugar(CXVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::VectorType *>(T)->desugar().getAsOpaquePtr());
}

CXVectorKind clang_VectorType_getVectorKind(CXVectorType T) {
  return static_cast<CXVectorKind>(reinterpret_cast<clang::VectorType *>(T)->getVectorKind());
}

// DependentVectorType
CXQualType clang_DependentVectorType_getElementType(CXDependentVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentVectorType *>(T)->getElementType().getAsOpaquePtr());
}

CXExpr clang_DependentVectorType_getSizeExpr(CXDependentVectorType T) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DependentVectorType *>(T)->getSizeExpr());
}

CXSourceLocation_ clang_DependentVectorType_getAttributeLoc(CXDependentVectorType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DependentVectorType *>(T)->getAttributeLoc().getPtrEncoding());
}

CXVectorKind clang_DependentVectorType_getVectorKind(CXDependentVectorType T) {
  return static_cast<CXVectorKind>(
      reinterpret_cast<clang::DependentVectorType *>(T)->getVectorKind());
}

bool clang_DependentVectorType_isSugared(CXDependentVectorType T) {
  return reinterpret_cast<clang::DependentVectorType *>(T)->isSugared();
}

CXQualType clang_DependentVectorType_desugar(CXDependentVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentVectorType *>(T)->desugar().getAsOpaquePtr());
}

// ExtVectorType
int clang_ExtVectorType_getPointAccessorIdx(char C) {
  return clang::ExtVectorType::getPointAccessorIdx(C);
}

int clang_ExtVectorType_getNumericAccessorIdx(char C) {
  return clang::ExtVectorType::getNumericAccessorIdx(C);
}

int clang_ExtVectorType_getAccessorIdx(char C, bool IsNumericAccessor) {
  return clang::ExtVectorType::getAccessorIdx(C, IsNumericAccessor);
}

bool clang_ExtVectorType_isAccessorWithinNumElements(CXExtVectorType T, char C,
                                                     bool IsNumericAccessor) {
  return reinterpret_cast<clang::ExtVectorType *>(T)->isAccessorWithinNumElements(
      C, IsNumericAccessor);
}

bool clang_ExtVectorType_isSugared(CXExtVectorType T) {
  return reinterpret_cast<clang::ExtVectorType *>(T)->isSugared();
}

CXQualType clang_ExtVectorType_desugar(CXExtVectorType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ExtVectorType *>(T)->desugar().getAsOpaquePtr());
}

// MatrixType
bool clang_MatrixType_isValidElementType(CXQualType T) {
  return clang::MatrixType::isValidElementType(clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_MatrixType_getElementType(CXMatrixType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MatrixType *>(T)->getElementType().getAsOpaquePtr());
}

bool clang_MatrixType_isSugared(CXMatrixType T) {
  return reinterpret_cast<clang::MatrixType *>(T)->isSugared();
}

CXQualType clang_MatrixType_desugar(CXMatrixType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MatrixType *>(T)->desugar().getAsOpaquePtr());
}

// ConstantMatrixType
unsigned clang_ConstantMatrixType_getMaxElementsPerDimension(void) {
  return clang::ConstantMatrixType::getMaxElementsPerDimension();
}

bool clang_ConstantMatrixType_isDimensionValid(size_t NumElements) {
  return clang::ConstantMatrixType::isDimensionValid(NumElements);
}

unsigned clang_ConstantMatrixType_getNumRows(CXConstantMatrixType T) {
  return reinterpret_cast<clang::ConstantMatrixType *>(T)->getNumRows();
}

unsigned clang_ConstantMatrixType_getNumColumns(CXConstantMatrixType T) {
  return reinterpret_cast<clang::ConstantMatrixType *>(T)->getNumColumns();
}

unsigned clang_ConstantMatrixType_getNumElementsFlattened(CXConstantMatrixType T) {
  return reinterpret_cast<clang::ConstantMatrixType *>(T)->getNumElementsFlattened();
}

// DependentSizedMatrixType
CXExpr clang_DependentSizedMatrixType_getRowExpr(CXDependentSizedMatrixType T) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DependentSizedMatrixType *>(T)->getRowExpr());
}

CXExpr clang_DependentSizedMatrixType_getColumnExpr(CXDependentSizedMatrixType T) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DependentSizedMatrixType *>(T)->getColumnExpr());
}

CXSourceLocation_
clang_DependentSizedMatrixType_getAttributeLoc(CXDependentSizedMatrixType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DependentSizedMatrixType *>(T)
      ->getAttributeLoc()
      .getPtrEncoding());
}

// FunctionType
CXQualType clang_FunctionType_getReturnType(CXFunctionType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionType *>(T)->getReturnType().getAsOpaquePtr());
}

CXArmStateValue clang_FunctionType_getArmZAState(unsigned AttrBits) {
  return static_cast<CXArmStateValue>(clang::FunctionType::getArmZAState(AttrBits));
}

CXArmStateValue clang_FunctionType_getArmZT0State(unsigned AttrBits) {
  return static_cast<CXArmStateValue>(clang::FunctionType::getArmZT0State(AttrBits));
}

bool clang_FunctionType_getHasRegParm(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getHasRegParm();
}

unsigned clang_FunctionType_getRegParmType(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getRegParmType();
}

bool clang_FunctionType_getNoReturnAttr(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getNoReturnAttr();
}

bool clang_FunctionType_getCmseNSCallAttr(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getCmseNSCallAttr();
}

bool clang_FunctionType_getProducesResult(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getExtInfo().getProducesResult();
}

bool clang_FunctionType_getNoCallerSavedRegs(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getExtInfo().getNoCallerSavedRegs();
}

bool clang_FunctionType_getNoCfCheck(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->getExtInfo().getNoCfCheck();
}

bool clang_FunctionType_isConst(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->isConst();
}

bool clang_FunctionType_isVolatile(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->isVolatile();
}

bool clang_FunctionType_isRestrict(CXFunctionType T) {
  return reinterpret_cast<clang::FunctionType *>(T)->isRestrict();
}

CXCallingConv_ clang_FunctionType_getCallConv(CXFunctionType T) {
  return static_cast<CXCallingConv_>(
      reinterpret_cast<clang::FunctionType *>(T)->getCallConv());
}

CXQualType clang_FunctionType_getCallResultType(CXFunctionType T, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionType *>(T)
      ->getCallResultType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

CXString clang_FunctionType_getNameForCallConv(CXCallingConv_ CC) {
  return extra::makeCXString(
      clang::FunctionType::getNameForCallConv(static_cast<clang::CallingConv>(CC)).str());
}

// FunctionType::ExtParameterInfo
CXParameterABI clang_ExtParameterInfo_getABI(unsigned char Info) {
  return static_cast<CXParameterABI>(
      clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info).getABI());
}

unsigned char clang_ExtParameterInfo_withABI(unsigned char Info, CXParameterABI Kind) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info)
      .withABI(static_cast<clang::ParameterABI>(Kind))
      .getOpaqueValue();
}

bool clang_ExtParameterInfo_isConsumed(unsigned char Info) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info).isConsumed();
}

unsigned char clang_ExtParameterInfo_withIsConsumed(unsigned char Info, bool Consumed) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info)
      .withIsConsumed(Consumed)
      .getOpaqueValue();
}

bool clang_ExtParameterInfo_hasPassObjectSize(unsigned char Info) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info)
      .hasPassObjectSize();
}

unsigned char clang_ExtParameterInfo_withHasPassObjectSize(unsigned char Info) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info)
      .withHasPassObjectSize()
      .getOpaqueValue();
}

bool clang_ExtParameterInfo_isNoEscape(unsigned char Info) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info).isNoEscape();
}

unsigned char clang_ExtParameterInfo_withIsNoEscape(unsigned char Info, bool NoEscape) {
  return clang::FunctionType::ExtParameterInfo::getFromOpaqueValue(Info)
      .withIsNoEscape(NoEscape)
      .getOpaqueValue();
}

// FunctionNoProtoType
bool clang_FunctionNoProtoType_isSugared(CXFunctionNoProtoType T) {
  return reinterpret_cast<clang::FunctionNoProtoType *>(T)->isSugared();
}

CXQualType clang_FunctionNoProtoType_desugar(CXFunctionNoProtoType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionNoProtoType *>(T)->desugar().getAsOpaquePtr());
}

// FunctionProtoType
unsigned clang_FunctionProtoType_getMethodQuals(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->getMethodQuals().getAsOpaqueValue();
}

bool clang_FunctionProtoType_isParamConsumed(CXFunctionProtoType T, unsigned I) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->isParamConsumed(I);
}
unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->getNumParams();
}

CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T, unsigned i) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionProtoType *>(T)->getParamType(i).getAsOpaquePtr());
}

CXArrayRef clang_FunctionProtoType_getParamTypes(CXFunctionProtoType T) {
  auto arr = reinterpret_cast<clang::FunctionProtoType *>(T)->getParamTypes();
  return {arr.data(), arr.size()};
}

CXExceptionSpecificationType
clang_FunctionProtoType_getExceptionSpecType(CXFunctionProtoType T) {
  return static_cast<CXExceptionSpecificationType>(
      reinterpret_cast<clang::FunctionProtoType *>(T)->getExceptionSpecType());
}

bool clang_FunctionProtoType_hasExceptionSpec(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasExceptionSpec();
}

bool clang_FunctionProtoType_hasDynamicExceptionSpec(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasDynamicExceptionSpec();
}

bool clang_FunctionProtoType_hasNoexceptExceptionSpec(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasNoexceptExceptionSpec();
}

bool clang_FunctionProtoType_hasDependentExceptionSpec(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasDependentExceptionSpec();
}

bool clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)
      ->hasInstantiationDependentExceptionSpec();
}

unsigned clang_FunctionProtoType_getNumExceptions(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->getNumExceptions();
}

CXQualType clang_FunctionProtoType_getExceptionType(CXFunctionProtoType T, unsigned i) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionProtoType *>(T)->getExceptionType(i).getAsOpaquePtr());
}

CXExpr clang_FunctionProtoType_getNoexceptExpr(CXFunctionProtoType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::FunctionProtoType *>(T)->getNoexceptExpr()));
}

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecDecl(CXFunctionProtoType T) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionProtoType *>(T)->getExceptionSpecDecl());
}

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecTemplate(CXFunctionProtoType T) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::FunctionProtoType *>(T)->getExceptionSpecTemplate());
}

bool clang_FunctionProtoType_isNothrow(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->isNothrow();
}

bool clang_FunctionProtoType_isVariadic(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->isVariadic();
}

bool clang_FunctionProtoType_isTemplateVariadic(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->isTemplateVariadic();
}

bool clang_FunctionProtoType_hasTrailingReturn(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasTrailingReturn();
}

CXArrayRef clang_FunctionProtoType_param_types(CXFunctionProtoType T) {
  auto arr = reinterpret_cast<clang::FunctionProtoType *>(T)->param_types();
  return {arr.data(), arr.size()};
}

CXArrayRef clang_FunctionProtoType_exceptions(CXFunctionProtoType T) {
  auto arr = reinterpret_cast<clang::FunctionProtoType *>(T)->exceptions();
  return {arr.data(), arr.size()};
}

bool clang_FunctionProtoType_isSugared(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->isSugared();
}

CXQualType clang_FunctionProtoType_desugar(CXFunctionProtoType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::FunctionProtoType *>(T)->desugar().getAsOpaquePtr());
}

CXString clang_FunctionProtoType_printExceptionSpecificationAsString(CXFunctionProtoType T,
                                                                     CXASTContext Ctx) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::FunctionProtoType *>(T)->printExceptionSpecification(
      OS, C->getPrintingPolicy());
  return extra::makeCXString(Str);
}

CXSourceLocation_ clang_FunctionProtoType_getEllipsisLoc(CXFunctionProtoType T) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FunctionProtoType *>(T)->getEllipsisLoc().getPtrEncoding());
}

bool clang_FunctionProtoType_hasExtParameterInfos(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->hasExtParameterInfos();
}

unsigned char clang_FunctionProtoType_getExtParameterInfo(CXFunctionProtoType T,
                                                          unsigned I) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)
      ->getExtParameterInfo(I)
      .getOpaqueValue();
}

CXParameterABI clang_FunctionProtoType_getParameterABI(CXFunctionProtoType T, unsigned I) {
  return static_cast<CXParameterABI>(
      reinterpret_cast<clang::FunctionProtoType *>(T)->getParameterABI(I));
}

CXRefQualifierKind clang_FunctionProtoType_getRefQualifier(CXFunctionProtoType T) {
  return static_cast<CXRefQualifierKind>(
      reinterpret_cast<clang::FunctionProtoType *>(T)->getRefQualifier());
}

CXCanThrowResult clang_FunctionProtoType_canThrow(CXFunctionProtoType T) {
  return static_cast<CXCanThrowResult>(
      reinterpret_cast<clang::FunctionProtoType *>(T)->canThrow());
}

unsigned clang_FunctionProtoType_getAArch64SMEAttributes(CXFunctionProtoType T) {
  return reinterpret_cast<clang::FunctionProtoType *>(T)->getAArch64SMEAttributes();
}

// UnresolvedUsingType
CXUnresolvedUsingTypenameDecl clang_UnresolvedUsingType_getDecl(CXUnresolvedUsingType T) {
  return reinterpret_cast<CXUnresolvedUsingTypenameDecl>(reinterpret_cast<clang::UnresolvedUsingType *>(T)->getDecl());
}

bool clang_UnresolvedUsingType_isSugared(CXUnresolvedUsingType T) {
  return reinterpret_cast<clang::UnresolvedUsingType *>(T)->isSugared();
}

CXQualType clang_UnresolvedUsingType_desugar(CXUnresolvedUsingType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnresolvedUsingType *>(T)->desugar().getAsOpaquePtr());
}

// UsingType
CXUsingShadowDecl clang_UsingType_getFoundDecl(CXUsingType T) {
  return reinterpret_cast<CXUsingShadowDecl>(reinterpret_cast<clang::UsingType *>(T)->getFoundDecl());
}

CXQualType clang_UsingType_getUnderlyingType(CXUsingType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UsingType *>(T)->getUnderlyingType().getAsOpaquePtr());
}

bool clang_UsingType_isSugared(CXUsingType T) {
  return reinterpret_cast<clang::UsingType *>(T)->isSugared();
}

CXQualType clang_UsingType_desugar(CXUsingType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UsingType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_UsingType_typeMatchesDecl(CXUsingType T) {
  return reinterpret_cast<clang::UsingType *>(T)->typeMatchesDecl();
}

// TypedefType
CXTypedefNameDecl clang_TypedefType_getDecl(CXTypedefType T) {
  return reinterpret_cast<CXTypedefNameDecl>(reinterpret_cast<clang::TypedefType *>(T)->getDecl());
}

bool clang_TypedefType_isSugared(CXTypedefType T) {
  return reinterpret_cast<clang::TypedefType *>(T)->isSugared();
}

CXQualType clang_TypedefType_desugar(CXTypedefType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypedefType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_TypedefType_typeMatchesDecl(CXTypedefType T) {
  return reinterpret_cast<clang::TypedefType *>(T)->typeMatchesDecl();
}

// MacroQualifiedType
CXIdentifierInfo clang_MacroQualifiedType_getMacroIdentifier(CXMacroQualifiedType T) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::MacroQualifiedType *>(T)->getMacroIdentifier()));
}

CXQualType clang_MacroQualifiedType_getUnderlyingType(CXMacroQualifiedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MacroQualifiedType *>(T)->getUnderlyingType().getAsOpaquePtr());
}

CXQualType clang_MacroQualifiedType_getModifiedType(CXMacroQualifiedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MacroQualifiedType *>(T)->getModifiedType().getAsOpaquePtr());
}

bool clang_MacroQualifiedType_isSugared(CXMacroQualifiedType T) {
  return reinterpret_cast<clang::MacroQualifiedType *>(T)->isSugared();
}

CXQualType clang_MacroQualifiedType_desugar(CXMacroQualifiedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::MacroQualifiedType *>(T)->desugar().getAsOpaquePtr());
}

// TypeOfExprType
CXExpr clang_TypeOfExprType_getUnderlyingExpr(CXTypeOfExprType T) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::TypeOfExprType *>(T)->getUnderlyingExpr());
}

CXTypeOfKind clang_TypeOfExprType_getKind(CXTypeOfExprType T) {
  return static_cast<CXTypeOfKind>(reinterpret_cast<clang::TypeOfExprType *>(T)->getKind());
}

CXQualType clang_TypeOfExprType_desugar(CXTypeOfExprType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypeOfExprType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_TypeOfExprType_isSugared(CXTypeOfExprType T) {
  return reinterpret_cast<clang::TypeOfExprType *>(T)->isSugared();
}

// DependentTypeOfExprType

// TypeOfType
CXQualType clang_TypeOfType_getUnmodifiedType(CXTypeOfType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypeOfType *>(T)->getUnmodifiedType().getAsOpaquePtr());
}

CXQualType clang_TypeOfType_desugar(CXTypeOfType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypeOfType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_TypeOfType_isSugared(CXTypeOfType T) {
  return reinterpret_cast<clang::TypeOfType *>(T)->isSugared();
}

CXTypeOfKind clang_TypeOfType_getKind(CXTypeOfType T) {
  return static_cast<CXTypeOfKind>(reinterpret_cast<clang::TypeOfType *>(T)->getKind());
}

// DecltypeType
CXExpr clang_DecltypeType_getUnderlyingExpr(CXDecltypeType T) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::DecltypeType *>(T)->getUnderlyingExpr()));
}

CXQualType clang_DecltypeType_getUnderlyingType(CXDecltypeType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DecltypeType *>(T)->getUnderlyingType().getAsOpaquePtr());
}

bool clang_DecltypeType_isSugared(CXDecltypeType T) {
  return reinterpret_cast<clang::DecltypeType *>(T)->isSugared();
}

CXQualType clang_DecltypeType_desugar(CXDecltypeType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DecltypeType *>(T)->desugar().getAsOpaquePtr());
}

// DependentDecltypeType

// UnaryTransformType
bool clang_UnaryTransformType_isSugared(CXUnaryTransformType T) {
  return reinterpret_cast<clang::UnaryTransformType *>(T)->isSugared();
}

CXQualType clang_UnaryTransformType_desugar(CXUnaryTransformType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnaryTransformType *>(T)->desugar().getAsOpaquePtr());
}

CXQualType clang_UnaryTransformType_getUnderlyingType(CXUnaryTransformType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnaryTransformType *>(T)->getUnderlyingType().getAsOpaquePtr());
}

CXQualType clang_UnaryTransformType_getBaseType(CXUnaryTransformType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnaryTransformType *>(T)->getBaseType().getAsOpaquePtr());
}

CXUTTKind clang_UnaryTransformType_getUTTKind(CXUnaryTransformType T) {
  return static_cast<CXUTTKind>(reinterpret_cast<clang::UnaryTransformType *>(T)->getUTTKind());
}

// DependentUnaryTransformType

// TagType
bool clang_TagType_isBeingDefined(CXTagType T) {
  return reinterpret_cast<clang::TagType *>(T)->isBeingDefined();
}
CXTagDecl clang_TagType_getDecl(CXTagType T) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::TagType *>(T)->getDecl());
}

// RecordType
CXRecordDecl clang_RecordType_getDecl(CXRecordType T) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::RecordType *>(T)->getDecl());
}

bool clang_RecordType_hasConstFields(CXRecordType T) {
  return reinterpret_cast<clang::RecordType *>(T)->hasConstFields();
}

bool clang_RecordType_isSugared(CXRecordType T) {
  return reinterpret_cast<clang::RecordType *>(T)->isSugared();
}

CXQualType clang_RecordType_desugar(CXRecordType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::RecordType *>(T)->desugar().getAsOpaquePtr());
}

// EnumType
CXEnumDecl clang_EnumType_getDecl(CXEnumType T) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::EnumType *>(T)->getDecl());
}

bool clang_EnumType_isSugared(CXEnumType T) {
  return reinterpret_cast<clang::EnumType *>(T)->isSugared();
}

CXQualType clang_EnumType_desugar(CXEnumType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::EnumType *>(T)->desugar().getAsOpaquePtr());
}

// AttributedType
CXAttrKind clang_AttributedType_getAttrKind(CXAttributedType T) {
  return static_cast<CXAttrKind>(reinterpret_cast<clang::AttributedType *>(T)->getAttrKind());
}
CXQualType clang_AttributedType_getModifiedType(CXAttributedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AttributedType *>(T)->getModifiedType().getAsOpaquePtr());
}

CXQualType clang_AttributedType_getEquivalentType(CXAttributedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AttributedType *>(T)->getEquivalentType().getAsOpaquePtr());
}

bool clang_AttributedType_isSugared(CXAttributedType T) {
  return reinterpret_cast<clang::AttributedType *>(T)->isSugared();
}

CXQualType clang_AttributedType_desugar(CXAttributedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AttributedType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_AttributedType_isQualifier(CXAttributedType T) {
  return reinterpret_cast<clang::AttributedType *>(T)->isQualifier();
}

bool clang_AttributedType_isMSTypeSpec(CXAttributedType T) {
  return reinterpret_cast<clang::AttributedType *>(T)->isMSTypeSpec();
}

bool clang_AttributedType_isWebAssemblyFuncrefSpec(CXAttributedType T) {
  return reinterpret_cast<clang::AttributedType *>(T)->isWebAssemblyFuncrefSpec();
}

bool clang_AttributedType_isCallingConv(CXAttributedType T) {
  return reinterpret_cast<clang::AttributedType *>(T)->isCallingConv();
}

bool clang_AttributedType_getImmediateNullability(CXAttributedType T,
                                                  CXNullabilityKind *Out) {
  if (auto NK = reinterpret_cast<clang::AttributedType *>(T)->getImmediateNullability()) {
    *Out = static_cast<CXNullabilityKind>(*NK);
    return true;
  }
  return false;
}

CXAttrKind clang_AttributedType_getNullabilityAttrKind(CXNullabilityKind Kind) {
  return static_cast<CXAttrKind>(clang::AttributedType::getNullabilityAttrKind(
      static_cast<clang::NullabilityKind>(Kind)));
}

bool clang_AttributedType_stripOuterNullability(CXQualType *T, CXNullabilityKind *Out) {
  clang::QualType QT = clang::QualType::getFromOpaquePtr(*T);
  auto NK = clang::AttributedType::stripOuterNullability(QT);
  *T = reinterpret_cast<CXQualType>(QT.getAsOpaquePtr());
  if (!NK)
    return false;
  *Out = static_cast<CXNullabilityKind>(*NK);
  return true;
}

// BTFTagAttributedType

// TemplateTypeParmType
unsigned clang_TemplateTypeParmType_getDepth(CXTemplateTypeParmType T) {
  return reinterpret_cast<clang::TemplateTypeParmType *>(T)->getDepth();
}

unsigned clang_TemplateTypeParmType_getIndex(CXTemplateTypeParmType T) {
  return reinterpret_cast<clang::TemplateTypeParmType *>(T)->getIndex();
}

bool clang_TemplateTypeParmType_isParameterPack(CXTemplateTypeParmType T) {
  return reinterpret_cast<clang::TemplateTypeParmType *>(T)->isParameterPack();
}

CXTemplateTypeParmDecl clang_TemplateTypeParmType_getDecl(CXTemplateTypeParmType T) {
  return reinterpret_cast<CXTemplateTypeParmDecl>(reinterpret_cast<clang::TemplateTypeParmType *>(T)->getDecl());
}

bool clang_TemplateTypeParmType_isSugared(CXTemplateTypeParmType T) {
  return reinterpret_cast<clang::TemplateTypeParmType *>(T)->isSugared();
}

CXQualType clang_TemplateTypeParmType_desugar(CXTemplateTypeParmType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateTypeParmType *>(T)->desugar().getAsOpaquePtr());
}

CXIdentifierInfo clang_TemplateTypeParmType_getIdentifier(CXTemplateTypeParmType T) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::TemplateTypeParmType *>(T)->getIdentifier());
}

// SubstTemplateTypeParmType
CXQualType
clang_SubstTemplateTypeParmType_getReplacementType(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)
      ->getReplacementType()
      .getAsOpaquePtr());
}

CXDecl clang_SubstTemplateTypeParmType_getAssociatedDecl(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->getAssociatedDecl());
}

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmType_getReplacedParameter(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<CXTemplateTypeParmDecl>(const_cast<clang::TemplateTypeParmDecl *>(
      reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->getReplacedParameter()));
}

unsigned clang_SubstTemplateTypeParmType_getIndex(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->getIndex();
}

bool clang_SubstTemplateTypeParmType_getPackIndex(CXSubstTemplateTypeParmType T,
                                                  unsigned *Out) {
  if (auto Idx = reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->getPackIndex()) {
    *Out = *Idx;
    return true;
  }
  return false;
}

bool clang_SubstTemplateTypeParmType_isSugared(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->isSugared();
}

CXQualType clang_SubstTemplateTypeParmType_desugar(CXSubstTemplateTypeParmType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::SubstTemplateTypeParmType *>(T)->desugar().getAsOpaquePtr());
}

// SubstTemplateTypeParmPackType
CXDecl
clang_SubstTemplateTypeParmPackType_getAssociatedDecl(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->getAssociatedDecl());
}

CXTemplateTypeParmDecl clang_SubstTemplateTypeParmPackType_getReplacedParameter(
    CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<CXTemplateTypeParmDecl>(const_cast<clang::TemplateTypeParmDecl *>(
      reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->getReplacedParameter()));
}

unsigned clang_SubstTemplateTypeParmPackType_getIndex(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->getIndex();
}

bool clang_SubstTemplateTypeParmPackType_getFinal(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->getFinal();
}

unsigned clang_SubstTemplateTypeParmPackType_getNumArgs(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->getNumArgs();
}

bool clang_SubstTemplateTypeParmPackType_isSugared(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->isSugared();
}

CXQualType clang_SubstTemplateTypeParmPackType_desugar(CXSubstTemplateTypeParmPackType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)->desugar().getAsOpaquePtr());
}

CXArrayRef
clang_SubstTemplateTypeParmPackType_getArgumentPack(CXSubstTemplateTypeParmPackType T) {
  auto arr = reinterpret_cast<clang::SubstTemplateTypeParmPackType *>(T)
                 ->getArgumentPack()
                 .getPackAsArray();
  return {arr.data(), arr.size()};
}

// DeducedType
bool clang_DeducedType_isSugared(CXDeducedType T) {
  return reinterpret_cast<clang::DeducedType *>(T)->isSugared();
}

CXQualType clang_DeducedType_desugar(CXDeducedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DeducedType *>(T)->desugar().getAsOpaquePtr());
}

CXQualType clang_DeducedType_getDeducedType(CXDeducedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DeducedType *>(T)->getDeducedType().getAsOpaquePtr());
}

bool clang_DeducedType_isDeduced(CXDeducedType T) {
  return reinterpret_cast<clang::DeducedType *>(T)->isDeduced();
}

// AutoType
CXArrayRef clang_AutoType_getTypeConstraintArguments(CXAutoType T) {
  auto arr = reinterpret_cast<clang::AutoType *>(T)->getTypeConstraintArguments();
  return {arr.data(), arr.size()};
}
CXConceptDecl clang_AutoType_getTypeConstraintConcept(CXAutoType T) {
  return reinterpret_cast<CXConceptDecl>(reinterpret_cast<clang::AutoType *>(T)->getTypeConstraintConcept());
}

bool clang_AutoType_isConstrained(CXAutoType T) {
  return reinterpret_cast<clang::AutoType *>(T)->isConstrained();
}

bool clang_AutoType_isDecltypeAuto(CXAutoType T) {
  return reinterpret_cast<clang::AutoType *>(T)->isDecltypeAuto();
}

bool clang_AutoType_isGNUAutoType(CXAutoType T) {
  return reinterpret_cast<clang::AutoType *>(T)->isGNUAutoType();
}

CXAutoTypeKeyword clang_AutoType_getKeyword(CXAutoType T) {
  return static_cast<CXAutoTypeKeyword>(reinterpret_cast<clang::AutoType *>(T)->getKeyword());
}

// DeducedTemplateSpecializationType
CXTemplateName clang_DeducedTemplateSpecializationType_getTemplateName(
    CXDeducedTemplateSpecializationType T) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::DeducedTemplateSpecializationType *>(T)
      ->getTemplateName()
      .getAsVoidPointer());
}

// TemplateSpecializationType
bool clang_TemplateSpecializationType_isCurrentInstantiation(
    CXTemplateSpecializationType T) {
  return reinterpret_cast<clang::TemplateSpecializationType *>(T)->isCurrentInstantiation();
}

bool clang_TemplateSpecializationType_isTypeAlias(CXTemplateSpecializationType T) {
  return reinterpret_cast<clang::TemplateSpecializationType *>(T)->isTypeAlias();
}

CXQualType clang_TemplateSpecializationType_getAliasedType(CXTemplateSpecializationType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateSpecializationType *>(T)
      ->getAliasedType()
      .getAsOpaquePtr());
}

CXTemplateName
clang_TemplateSpecializationType_getTemplateName(CXTemplateSpecializationType T) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::TemplateSpecializationType *>(T)
      ->getTemplateName()
      .getAsVoidPointer());
}

CXArrayRef
clang_TemplateSpecializationType_template_arguments(CXTemplateSpecializationType T) {
  auto arr = reinterpret_cast<clang::TemplateSpecializationType *>(T)->template_arguments();
  return {arr.data(), arr.size()};
}

unsigned clang_TemplateSpecializationType_getNumArgs(CXTemplateSpecializationType T) {
  return reinterpret_cast<clang::TemplateSpecializationType *>(T)->template_arguments().size();
}

// Borrowed interior pointer into the type's trailing TemplateArgument storage
// (AST-arena owned; no dispose).
CXTemplateArgument
clang_TemplateSpecializationType_getArg(CXTemplateSpecializationType T, unsigned Idx) {
  return reinterpret_cast<CXTemplateArgument>(const_cast<clang::TemplateArgument *>(
      &reinterpret_cast<clang::TemplateSpecializationType *>(T)->template_arguments()[Idx]));
}

bool clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T) {
  return reinterpret_cast<clang::TemplateSpecializationType *>(T)->isSugared();
}

CXQualType clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TemplateSpecializationType *>(T)->desugar().getAsOpaquePtr());
}

// InjectedClassNameType
CXQualType
clang_InjectedClassNameType_getInjectedSpecializationType(CXInjectedClassNameType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::InjectedClassNameType *>(T)
      ->getInjectedSpecializationType()
      .getAsOpaquePtr());
}

CXTemplateSpecializationType
clang_InjectedClassNameType_getInjectedTST(CXInjectedClassNameType T) {
  return reinterpret_cast<CXTemplateSpecializationType>(const_cast<clang::TemplateSpecializationType *>(
      reinterpret_cast<clang::InjectedClassNameType *>(T)->getInjectedTST()));
}

CXTemplateName clang_InjectedClassNameType_getTemplateName(CXInjectedClassNameType T) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::InjectedClassNameType *>(T)
      ->getTemplateName()
      .getAsVoidPointer());
}

CXCXXRecordDecl clang_InjectedClassNameType_getDecl(CXInjectedClassNameType T) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::InjectedClassNameType *>(T)->getDecl());
}

bool clang_InjectedClassNameType_isSugared(CXInjectedClassNameType T) {
  return reinterpret_cast<clang::InjectedClassNameType *>(T)->isSugared();
}

CXQualType clang_InjectedClassNameType_desugar(CXInjectedClassNameType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::InjectedClassNameType *>(T)->desugar().getAsOpaquePtr());
}

// TypeWithKeyword

// ElaboratedType
CXNestedNameSpecifier clang_ElaboratedType_getQualifier(CXElaboratedType T) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::ElaboratedType *>(T)->getQualifier());
}

CXQualType clang_ElaboratedType_getNamedType(CXElaboratedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ElaboratedType *>(T)->getNamedType().getAsOpaquePtr());
}

CXQualType clang_ElaboratedType_desugar(CXElaboratedType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ElaboratedType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_ElaboratedType_isSugared(CXElaboratedType T) {
  return reinterpret_cast<clang::ElaboratedType *>(T)->isSugared();
}

CXTagDecl clang_ElaboratedType_getOwnedTagDecl(CXElaboratedType T) {
  return reinterpret_cast<CXTagDecl>(reinterpret_cast<clang::ElaboratedType *>(T)->getOwnedTagDecl());
}

// DependentNameType
CXNestedNameSpecifier clang_DependentNameType_getQualifier(CXDependentNameType T) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::DependentNameType *>(T)->getQualifier());
}

CXIdentifierInfo clang_DependentNameType_getIdentifier(CXDependentNameType T) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::DependentNameType *>(T)->getIdentifier()));
}

bool clang_DependentNameType_isSugared(CXDependentNameType T) {
  return reinterpret_cast<clang::DependentNameType *>(T)->isSugared();
}

CXQualType clang_DependentNameType_desugar(CXDependentNameType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentNameType *>(T)->desugar().getAsOpaquePtr());
}

// DependentTemplateSpecializationType
CXNestedNameSpecifier clang_DependentTemplateSpecializationType_getQualifier(
    CXDependentTemplateSpecializationType T) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::DependentTemplateSpecializationType *>(T)->getQualifier());
}

CXIdentifierInfo clang_DependentTemplateSpecializationType_getIdentifier(
    CXDependentTemplateSpecializationType T) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::DependentTemplateSpecializationType *>(T)->getIdentifier()));
}

CXArrayRef clang_DependentTemplateSpecializationType_template_arguments(
    CXDependentTemplateSpecializationType T) {
  auto arr =
      reinterpret_cast<clang::DependentTemplateSpecializationType *>(T)->template_arguments();
  return {arr.data(), arr.size()};
}

bool clang_DependentTemplateSpecializationType_isSugared(
    CXDependentTemplateSpecializationType T) {
  return reinterpret_cast<clang::DependentTemplateSpecializationType *>(T)->isSugared();
}

CXQualType
clang_DependentTemplateSpecializationType_desugar(CXDependentTemplateSpecializationType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentTemplateSpecializationType *>(T)
      ->desugar()
      .getAsOpaquePtr());
}

// PackExpansionType
CXQualType clang_PackExpansionType_getPattern(CXPackExpansionType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PackExpansionType *>(T)->getPattern().getAsOpaquePtr());
}

bool clang_PackExpansionType_getNumExpansions(CXPackExpansionType T, unsigned *N) {
  if (auto Num = reinterpret_cast<clang::PackExpansionType *>(T)->getNumExpansions()) {
    *N = *Num;
    return true;
  }
  return false;
}

bool clang_PackExpansionType_isSugared(CXPackExpansionType T) {
  return reinterpret_cast<clang::PackExpansionType *>(T)->isSugared();
}

CXQualType clang_PackExpansionType_desugar(CXPackExpansionType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PackExpansionType *>(T)->desugar().getAsOpaquePtr());
}

// ObjCTypeParamType
CXObjCTypeParamDecl clang_ObjCTypeParamType_getDecl(CXObjCTypeParamType T) {
  return reinterpret_cast<CXObjCTypeParamDecl>(
      reinterpret_cast<clang::ObjCTypeParamType *>(T)->getDecl());
}

unsigned clang_ObjCTypeParamType_getNumProtocols(CXObjCTypeParamType T) {
  return reinterpret_cast<clang::ObjCTypeParamType *>(T)->getNumProtocols();
}

CXObjCProtocolDecl clang_ObjCTypeParamType_getProtocol(CXObjCTypeParamType T, unsigned I) {
  return reinterpret_cast<CXObjCProtocolDecl>(
      reinterpret_cast<clang::ObjCTypeParamType *>(T)->getProtocol(I));
}

bool clang_ObjCTypeParamType_isSugared(CXObjCTypeParamType T) {
  return reinterpret_cast<clang::ObjCTypeParamType *>(T)->isSugared();
}

CXQualType clang_ObjCTypeParamType_desugar(CXObjCTypeParamType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCTypeParamType *>(T)->desugar().getAsOpaquePtr());
}

// ObjCObjectType
CXQualType clang_ObjCObjectType_getBaseType(CXObjCObjectType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->getBaseType().getAsOpaquePtr());
}

CXObjCInterfaceDecl clang_ObjCObjectType_getInterface(CXObjCObjectType T) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->getInterface());
}

bool clang_ObjCObjectType_isObjCId(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isObjCId();
}

bool clang_ObjCObjectType_isObjCClass(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isObjCClass();
}

bool clang_ObjCObjectType_isObjCUnqualifiedId(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isObjCUnqualifiedId();
}

bool clang_ObjCObjectType_isObjCQualifiedId(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isObjCQualifiedId();
}

bool clang_ObjCObjectType_isSpecialized(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isSpecialized();
}

bool clang_ObjCObjectType_isKindOfType(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isKindOfType();
}

unsigned clang_ObjCObjectType_getNumTypeArgs(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->getTypeArgs().size();
}

CXQualType clang_ObjCObjectType_getTypeArg(CXObjCObjectType T, unsigned I) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->getTypeArgs()[I].getAsOpaquePtr());
}

unsigned clang_ObjCObjectType_getNumProtocols(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->getNumProtocols();
}

CXObjCProtocolDecl clang_ObjCObjectType_getProtocol(CXObjCObjectType T, unsigned I) {
  return reinterpret_cast<CXObjCProtocolDecl>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->getProtocol(I));
}

CXQualType clang_ObjCObjectType_getSuperClassType(CXObjCObjectType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->getSuperClassType().getAsOpaquePtr());
}

bool clang_ObjCObjectType_isSugared(CXObjCObjectType T) {
  return reinterpret_cast<clang::ObjCObjectType *>(T)->isSugared();
}

CXQualType clang_ObjCObjectType_desugar(CXObjCObjectType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectType *>(T)->desugar().getAsOpaquePtr());
}

// ObjCInterfaceType
CXObjCInterfaceDecl clang_ObjCInterfaceType_getDecl(CXObjCInterfaceType T) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCInterfaceType *>(T)->getDecl());
}

bool clang_ObjCInterfaceType_isSugared(CXObjCInterfaceType T) {
  return reinterpret_cast<clang::ObjCInterfaceType *>(T)->isSugared();
}

CXQualType clang_ObjCInterfaceType_desugar(CXObjCInterfaceType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCInterfaceType *>(T)->desugar().getAsOpaquePtr());
}

// ObjCObjectPointerType
CXQualType clang_ObjCObjectPointerType_getPointeeType(CXObjCObjectPointerType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectPointerType *>(T)->getPointeeType().getAsOpaquePtr());
}

CXObjCObjectType clang_ObjCObjectPointerType_getObjectType(CXObjCObjectPointerType T) {
  return reinterpret_cast<CXObjCObjectType>(const_cast<clang::ObjCObjectType *>(
      reinterpret_cast<clang::ObjCObjectPointerType *>(T)->getObjectType()));
}

CXObjCInterfaceDecl clang_ObjCObjectPointerType_getInterfaceDecl(CXObjCObjectPointerType T) {
  return reinterpret_cast<CXObjCInterfaceDecl>(
      reinterpret_cast<clang::ObjCObjectPointerType *>(T)->getInterfaceDecl());
}

bool clang_ObjCObjectPointerType_isObjCIdType(CXObjCObjectPointerType T) {
  return reinterpret_cast<clang::ObjCObjectPointerType *>(T)->isObjCIdType();
}

bool clang_ObjCObjectPointerType_isObjCClassType(CXObjCObjectPointerType T) {
  return reinterpret_cast<clang::ObjCObjectPointerType *>(T)->isObjCClassType();
}

bool clang_ObjCObjectPointerType_isObjCQualifiedIdType(CXObjCObjectPointerType T) {
  return reinterpret_cast<clang::ObjCObjectPointerType *>(T)->isObjCQualifiedIdType();
}

unsigned clang_ObjCObjectPointerType_getNumProtocols(CXObjCObjectPointerType T) {
  return reinterpret_cast<clang::ObjCObjectPointerType *>(T)->getNumProtocols();
}

CXObjCProtocolDecl clang_ObjCObjectPointerType_getProtocol(CXObjCObjectPointerType T,
                                                           unsigned I) {
  return reinterpret_cast<CXObjCProtocolDecl>(
      reinterpret_cast<clang::ObjCObjectPointerType *>(T)->getProtocol(I));
}

bool clang_ObjCObjectPointerType_isSugared(CXObjCObjectPointerType T) {
  return reinterpret_cast<clang::ObjCObjectPointerType *>(T)->isSugared();
}

CXQualType clang_ObjCObjectPointerType_desugar(CXObjCObjectPointerType T) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::ObjCObjectPointerType *>(T)->desugar().getAsOpaquePtr());
}

// AtomicType
CXQualType clang_AtomicType_getValueType(CXAtomicType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AtomicType *>(T)->getValueType().getAsOpaquePtr());
}

bool clang_AtomicType_isSugared(CXAtomicType T) {
  return reinterpret_cast<clang::AtomicType *>(T)->isSugared();
}

CXQualType clang_AtomicType_desugar(CXAtomicType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AtomicType *>(T)->desugar().getAsOpaquePtr());
}

CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeyword(CXTypeWithKeyword T) {
  return static_cast<CXElaboratedTypeKeyword>(
      reinterpret_cast<clang::TypeWithKeyword *>(T)->getKeyword());
}

CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeywordForTypeSpec(unsigned TypeSpec) {
  return static_cast<CXElaboratedTypeKeyword>(
      clang::TypeWithKeyword::getKeywordForTypeSpec(TypeSpec));
}

CXTagTypeKind clang_TypeWithKeyword_getTagTypeKindForTypeSpec(unsigned TypeSpec) {
  return static_cast<CXTagTypeKind>(
      clang::TypeWithKeyword::getTagTypeKindForTypeSpec(TypeSpec));
}

CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeywordForTagTypeKind(CXTagTypeKind Tag) {
  clang::TagTypeKind K = static_cast<clang::TagTypeKind>(Tag);
  return static_cast<CXElaboratedTypeKeyword>(
      clang::TypeWithKeyword::getKeywordForTagTypeKind(K));
}

CXTagTypeKind
clang_TypeWithKeyword_getTagTypeKindForKeyword(CXElaboratedTypeKeyword Keyword) {
  clang::ElaboratedTypeKeyword K = static_cast<clang::ElaboratedTypeKeyword>(Keyword);
  return static_cast<CXTagTypeKind>(clang::TypeWithKeyword::getTagTypeKindForKeyword(K));
}

bool clang_TypeWithKeyword_KeywordIsTagTypeKind(CXElaboratedTypeKeyword Keyword) {
  return clang::TypeWithKeyword::KeywordIsTagTypeKind(
      static_cast<clang::ElaboratedTypeKeyword>(Keyword));
}

CXString clang_TypeWithKeyword_getKeywordName(CXElaboratedTypeKeyword Keyword) {
  llvm::StringRef Name = clang::TypeWithKeyword::getKeywordName(
      static_cast<clang::ElaboratedTypeKeyword>(Keyword));
  return extra::makeCXString(Name.str());
}

CXString clang_TypeWithKeyword_getTagTypeKindName(CXTagTypeKind Kind) {
  llvm::StringRef Name =
      clang::TypeWithKeyword::getTagTypeKindName(static_cast<clang::TagTypeKind>(Kind));
  return extra::makeCXString(Name.str());
}

// PipeType
CXQualType clang_PipeType_getElementType(CXPipeType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PipeType *>(T)->getElementType().getAsOpaquePtr());
}

bool clang_PipeType_isSugared(CXPipeType T) {
  return reinterpret_cast<clang::PipeType *>(T)->isSugared();
}

CXQualType clang_PipeType_desugar(CXPipeType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::PipeType *>(T)->desugar().getAsOpaquePtr());
}

bool clang_PipeType_isReadOnly(CXPipeType T) {
  return reinterpret_cast<clang::PipeType *>(T)->isReadOnly();
}

// BitIntType
bool clang_BitIntType_isUnsigned(CXBitIntType T) {
  return reinterpret_cast<clang::BitIntType *>(T)->isUnsigned();
}

bool clang_BitIntType_isSigned(CXBitIntType T) {
  return reinterpret_cast<clang::BitIntType *>(T)->isSigned();
}

unsigned clang_BitIntType_getNumBits(CXBitIntType T) {
  return reinterpret_cast<clang::BitIntType *>(T)->getNumBits();
}

bool clang_BitIntType_isSugared(CXBitIntType T) {
  return reinterpret_cast<clang::BitIntType *>(T)->isSugared();
}

CXQualType clang_BitIntType_desugar(CXBitIntType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::BitIntType *>(T)->desugar().getAsOpaquePtr());
}

// DependentBitIntType
bool clang_DependentBitIntType_isUnsigned(CXDependentBitIntType T) {
  return reinterpret_cast<clang::DependentBitIntType *>(T)->isUnsigned();
}
bool clang_DependentBitIntType_isSigned(CXDependentBitIntType T) {
  return reinterpret_cast<clang::DependentBitIntType *>(T)->isSigned();
}

CXExpr clang_DependentBitIntType_getNumBitsExpr(CXDependentBitIntType T) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DependentBitIntType *>(T)->getNumBitsExpr());
}
// isSugared
// desugar
bool clang_DependentBitIntType_isSugared(CXDependentBitIntType T) {
  return reinterpret_cast<clang::DependentBitIntType *>(T)->isSugared();
}

CXQualType clang_DependentBitIntType_desugar(CXDependentBitIntType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::DependentBitIntType *>(T)->desugar().getAsOpaquePtr());
}
// TypeSourceInfo
CXQualType clang_TypeSourceInfo_getType(CXTypeSourceInfo TSI) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::TypeSourceInfo *>(TSI)->getType().getAsOpaquePtr());
}

void clang_TypeSourceInfo_overrideType(CXTypeSourceInfo TSI, CXQualType T) {
  reinterpret_cast<clang::TypeSourceInfo *>(TSI)->overrideType(
      clang::QualType::getFromOpaquePtr(T));
}
