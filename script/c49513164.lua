--召喚獣ライディーン
--Raideen the Eidolon Beast
--Scripted by Eerie Code
function c49513164.initial_effect(c)
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND,c),1,true,true)
	else
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,true,true)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49513164,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c49513164.target)
	e1:SetOperation(c49513164.activate)
	c:RegisterEffect(e1)
end

function c49513164.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c49513164.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49513164.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49513164.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c49513164.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c49513164.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end