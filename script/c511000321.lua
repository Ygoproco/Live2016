--Love Letter
function c511000321.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000321.target)
	e1:SetOperation(c511000321.activate)
	c:RegisterEffect(e1)
end
function c511000321.filter1(c)
	return c:IsControlerCanBeChanged()
end
function c511000321.filter2(c)
	return c:IsFacedown() and c:IsAbleToChangeControler()
end
function c511000321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c511000321.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c511000321.filter2,tp,LOCATION_SZONE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c511000321.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.SelectOption(1-tp,aux.Stringid(511000321,0),aux.Stringid(511000321,1))
	if op==0 then
		local g=Duel.SelectMatchingCard(1-tp,c511000321.filter1,1-tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		Duel.GetControl(tc,1-tp)
	else
		local g=Duel.SelectMatchingCard(1-tp,c511000321.filter2,1-tp,0,LOCATION_SZONE,1,1,c)
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
end
