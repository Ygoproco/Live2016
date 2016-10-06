--召喚獣エリュシオン
--Elysion the Eidolon Beast
--Scripted by Eerie Code
function c7633.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf4),c7633.mat_fil,false)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0x2f)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7633,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c7633.rmtg)
	e2:SetOperation(c7633.rmop)
	c:RegisterEffect(e2)
end

function c7633.mat_fil(c)
	return c:GetPreviousLocation()==LOCATION_EXTRA
end

function c7633.rmcfil(c,tp)
	return c:IsSetCard(0xf4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
	and Duel.IsExistingMatchingCard(c7633.rmfil,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c7633.rmfil(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr) and c:IsAbleToRemove()
end
function c7633.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chck:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c7633.rmcfil(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c7633.rmcfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c7633.rmcfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	local rg=Duel.GetMatchingGroup(c7633.rmfil,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttribute())
	g:Merge(rg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c7633.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c7633.rmfil,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	g:AddCard(tc)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end