--Shade of the King
function c511002164.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511002164.condition)
	e1:SetTarget(c511002164.target)
	e1:SetOperation(c511002164.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c511002164.condition2)
	c:RegisterEffect(e2)
end
function c511002164.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not tc:IsType(TYPE_XYZ) or tc:GetRank()<=7 then
		tc=Duel.GetAttackTarget()
		bc=Duel.GetAttacker()
	end
	if not tc or not bc or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then return false end
	if tc:GetRank()<=7 or not tc:IsType(TYPE_XYZ) then return false end
	if bc:GetRank()>7 and bc:IsType(TYPE_XYZ) then return false end
	e:SetLabelObject(tc)
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
		if not bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
			if bc:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 then
				if tc:IsAttackPos() then
					if bc:GetDefense()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return bc:GetDefense()~=0
					else
						return bc:GetDefense()>=tc:GetAttack()
					end
				else
					return bc:GetDefense()>tc:GetDefense()
				end
			elseif bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if tc:IsAttackPos() then
					if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return bc:GetAttack()~=0
					else
						return bc:GetAttack()>=tc:GetAttack()
					end
				else
					return bc:GetAttack()>tc:GetDefense()
				end
			end
		end
	else
		if tc:IsAttackPos() then
			if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
				return bc:GetAttack()~=0
			else
				return bc:GetAttack()>=tc:GetAttack()
			end
		else
			return bc:GetAttack()>tc:GetDefense()
		end
	end
end
function c511002164.cfilter(c,e)
	return c:IsOnField() and c:IsType(TYPE_XYZ) and c:GetRank()>=8 and (not e or c:IsRelateToEffect(e))
end
function c511002164.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil then return false end
	local g=tg:Filter(c511002164.cfilter,nil,nil)
	if ex and g:GetCount()==1 then
		e:SetLabelObject(g:GetFirst())
		return true
	else
		return false
	end
end
function c511002164.filter2(c,e,tp,mc,rk,code)
	if c:GetOriginalCode()==6165656 and code~=48995978 then return false end
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and Duel.IsExistingMatchingCard(c511002164.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511002164.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if tc:IsControler(1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511002164.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.SendtoGrave(mg,REASON_RULE)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		sc:RegisterEffect(e2)
	end
end
