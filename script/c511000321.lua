--Love Letter
function c511000321.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000321.condition)
	e1:SetTarget(c511000321.target)
	e1:SetOperation(c511000321.activate)
	c:RegisterEffect(e1)
end
function c511000321.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 
		and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,c)
end
function c511000321.filter(c)
	return c:IsFacedown() and c:IsAbleToChangeControler()
end
function c511000321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil) 
		or Duel.IsExistingMatchingCard(c511000321.filter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c511000321.activate(e,tp,eg,ep,ev,re,r,rp)
	local con1=Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil)
	local con2=Duel.IsExistingMatchingCard(c511000321.filter,tp,LOCATION_SZONE,0,1,e:GetHandler())
	local op=2
	if con1 and con2 then
		op=Duel.SelectOption(1-tp,aux.Stringid(24413299,0),aux.Stringid(511000321,1))
	elseif con1 then
		Duel.SelectOption(1-tp,aux.Stringid(24413299,0))
		op=0
	elseif con2 then
		Duel.SelectOption(1-tp,aux.Stringid(511000321,0))
		op=1
	end
	if op==0 then
		local g=Duel.SelectMatchingCard(1-tp,Card.IsControlerCanBeChanged,1-tp,0,LOCATION_MZONE,1,1,nil)
		Duel.GetControl(g:GetFirst(),1-tp)
	elseif op==1 then
		local g=Duel.SelectMatchingCard(1-tp,c511000321.filter,1-tp,0,LOCATION_SZONE,1,1,e:GetHandler())
		Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
end
