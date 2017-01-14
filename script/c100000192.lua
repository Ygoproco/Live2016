--ドリーム・ダイス
function c100000192.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100000192.con)
	e1:SetTarget(c100000192.target)
	e1:SetOperation(c100000192.operation)
	c:RegisterEffect(e1)
end
function c100000192.con(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0  
end
function c100000192.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c100000192.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	local c=e:GetHandler()
	local sg=nil
	if d==6 then 
		sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	else
		sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	end
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()	
	end
end
