--Contagion of Madness
function c511000408.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c511000408.target)
	e1:SetOperation(c511000408.activate)
	c:RegisterEffect(e1)
end
function c511000408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() end
	local dam=tg:GetAttack()
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function c511000408.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetAttacker()
    local ap=tc:GetControler()
	if tc:IsFaceup() and tc:IsAttackable() then
		if Duel.NegateAttack() then
			Duel.Damage(1-ap,d,REASON_BATTLE)
            Duel.Damage(ap,d/2,REASON_EFFECT)
		end
	end
end